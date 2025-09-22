data "aws_ami" "blackweb_agency" {
  owners      = ["973714476881"] # Replace with the correct AWS Account ID
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "vpc" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
   name = "/${var.project}/${var.environment}/catalogue"
}

data "aws_ssm_parameter" "alb_arn" {
  name = "/${var.project}/${var.environment}/backend-alb"
}