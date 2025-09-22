resource "aws_ssm_parameter" "backend_alb" {
  name = "/${var.project}/${var.environment}/backend-alb"
  type = "String"
  value = aws_lb_listener.backend_alb.arn
}