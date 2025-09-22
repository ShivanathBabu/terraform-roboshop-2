resource "aws_instance" "mongodb" {
  ami = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id = local.subnet
  iam_instance_profile = "EC2_role_To_fetch_ssmparameter"

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

# null resource

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]

  provisioner "file" {
    source = "bootstap.sh"
    destination = "/tmp/bootstap.sh"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mongodb.private_ip
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstap.sh",
        "sudo sh /tmp/bootstap.sh mongodb ${var.environment}"
     ]
  }

}


# redis

resource "aws_instance" "redis" {
  ami = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.reddis_sg_id]
  subnet_id = local.subnet
  iam_instance_profile = "EC2_role_To_fetch_ssmparameter"

   tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-redis"
    }
  )

}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]

  provisioner "file" {
    source = "bootstap.sh"
    destination = "/tmp/bootstap.sh"
}

  connection {
    user = "ec2-user"
    password = "DevOps321"
    type = "ssh"
    host = aws_instance.redis.private_ip
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstap.sh",
      "sudo sh /tmp/bootstap.sh  redis ${var.environment}"
     ]
  }
}


# rabbitmq

resource "aws_instance" "rabbitmq" {
  ami = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id = local.subnet
  iam_instance_profile = "EC2_role_To_fetch_ssmparameter"

     tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-rabbitmq"
    }
  )
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]

  provisioner "file" {
    source = "bootstap.sh"
    destination = "/tmp/bootstap.sh"

  }

   connection {
    user = "ec2-user"
    password = "DevOps321"
    type = "ssh"
    host = aws_instance.rabbitmq.private_ip
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstap.sh",
      "sudo sh /tmp/bootstap.sh  rabbitmq ${var.environment}"
     ]
  }
}

# mysql

resource "aws_instance" "mysql" {
  ami = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id = local.subnet
  iam_instance_profile = "EC2_role_To_fetch_ssmparameter"

     tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-mysql"
    }
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

  provisioner "file" {
    source = "bootstap.sh"
    destination = "/tmp/bootstap.sh"

  }

   connection {
    user = "ec2-user"
    password = "DevOps321"
    type = "ssh"
    host = aws_instance.mysql.private_ip
  }

  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstap.sh",
      "sudo sh /tmp/bootstap.sh  mysql ${var.environment}"
     ]
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name = "mongodb-${var.environment}.${var.zone_name}"
  type = "A"
  ttl =1
  records = [aws_instance.mongodb.private_ip]
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name = "redis-${var.environment}.${var.zone_name}"
  type = "A"
  ttl = 1
  records = [aws_instance.redis.private_ip]
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name = "rabbitmq-${var.environment}.${var.zone_name}"
  type = "A"
  ttl = 1
  records = [aws_instance.rabbitmq.private_ip]
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name = "mysql-${var.environment}.${var.zone_name}"
  type = "A"
  ttl = 1
  records = [aws_instance.mysql.private_ip]
}



