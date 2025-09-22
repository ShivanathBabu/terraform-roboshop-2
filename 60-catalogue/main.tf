resource "aws_lb_target_group" "test" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc
  deregistration_delay = 120
  health_check {
    healthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/health"
    port = 8080
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_instance" "catalogue" {
  ami = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.sg]
  iam_instance_profile = "EC2_role_To_fetch_ssmparameter"
  subnet_id = local.subnet
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-catalogue"
    }
  )

}


resource "terraform_data" "name" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  provisioner "file" {
    source = "bootstap.sh"
    destination = "/tmp/bootstap.sh"
  }

  connection {
    user = "ec2-user"
    password = "DevOps321"
    type = "ssh"
    host = aws_instance.catalogue.private_ip

  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x bootstap.sh",
        "sudo sh /tmp/bootstap.sh  catalogue ${var.environment}"
     ]
  }
}

resource "aws_ec2_instance_state" "stop_my_instance" {
      instance_id = aws_instance.catalogue.id
      state       = "stopped"
      depends_on = [ terraform_data.name ]
    }

resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "${var.project}-${var.environment}-catalogue"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.stop_my_instance ]
   tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-catalogue"
    }
  )

  }

  resource "terraform_data" "catalogue_delete" {
    triggers_replace = [
      aws_instance.catalogue.id
    ]

    provisioner "local-exec" {
      command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
    }

    depends_on = [ aws_ami_from_instance.catalogue_ami]
  }

# aws launch template

resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"

 

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  } 

  image_id = aws_ami_from_instance.catalogue_ami.id
  instance_initiated_shutdown_behavior = "terminate" # terminate instance when asg removes instance
  instance_type = "t3.micro"
  update_default_version = true # each time update new version will become default instead of creating new template
  vpc_security_group_ids = [local.sg]
# instance tags created by asg
  tag_specifications {
    resource_type = "instance"

      tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-catalogue"
    }
  )
  }
# volume tags created by asg
   tag_specifications {
    resource_type = "volume"

      tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-catalogue"
    }
  )
  }

# launch template tags
 tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-catalogue"
    }
  )
  
}


# auto scaling group

resource "aws_autoscaling_group" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"
  desired_capacity   = 2
  max_size           = 10
  min_size           = 1
  target_group_arns = [aws_lb_target_group.test.arn]
  vpc_zone_identifier = local.subnets
   health_check_grace_period = 90
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

dynamic "tag" {
  for_each = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  )
  content {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }
}
  

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
   
   timeouts {
    delete = "15m"
  }


}

resource "aws_autoscaling_policy" "catalogue" {
  name                   = "${var.project}-${var.environment}-catalogue"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = local.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-${var.environment}.${var.zone_name}"]
    }
  }
}