locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_cidr_block = split("," , data.aws_ssm_parameter.private_subnet_ids.value)
  backen_alb_sg_id = data.aws_ssm_parameter.backen_alb.value

   common_tags = {
    project = var.project
    environment = var.environment
    terraform = true
  }
}