locals {
  vpc = data.aws_ssm_parameter.vpc.value
  subnet = split (",",data.aws_ssm_parameter.private_subnet.value)[0]
  subnets = split (",",data.aws_ssm_parameter.private_subnet.value)
  ami = data.aws_ami.blackweb_agency.id
  sg = data.aws_ssm_parameter.catalogue_sg_id.value
  arn = data.aws_ssm_parameter.alb_arn.value

  common_tags = {
    project = var.project
    environment = var.environment
  }

}