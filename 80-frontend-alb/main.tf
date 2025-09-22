module "front_end" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.16.0"

  name    = "${var.project}-${var.environment}-frontend-alb"
  vpc_id  = local.vpc_id
  subnets = local.subnet
  internal = false
  create_security_group = false
  security_groups = [local.sg]
  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-frontend-alb"
    }
  )
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = module.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn =  local.crt_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello I am Frontend ALB using HTTPS"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "front_end" {
  zone_id = var.zone_id
  name    = "${var.environment}.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.front_end.dns_name
    zone_id                = module.front_end.zone_id
    evaluate_target_health = true
  }
}