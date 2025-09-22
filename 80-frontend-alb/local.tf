locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  subnet = split("," ,data.aws_ssm_parameter.public_subnet.value)
  sg = data.aws_ssm_parameter.frontend_alb.value
  crt_arn = data.aws_ssm_parameter.certificate_arn.value
   common_tags = {
    project = var.project
    environment = var.environment
    terraform = true
  }

}