resource "aws_ssm_parameter" "front_backend_alb" {
  name = "/${var.project}/${var.environment}/front_alb_arn"
  type = "String"
  value = aws_lb_listener.front_end.arn
}