locals {
  common_tags = {
    project = var.project
    environment = var.environment
  }

  ami = data.aws_ami.example.id
  vpn = data.aws_ssm_parameter.vpn.value
  subnets = split (",", data.aws_ssm_parameter.public_subnet.value)[0]
}