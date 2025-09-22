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

data "aws_ssm_parameter" "mongodb" {
  name = "/${var.project}/${var.environment}/mongodb"
}

data "aws_ssm_parameter" "reddis" {
  name = "/${var.project}/${var.environment}/redis"
}

data "aws_ssm_parameter" "rabbitmq" {
  name = "/${var.project}/${var.environment}/rabbitmq"
}

data "aws_ssm_parameter" "mysql" {
  name = "/${var.project}/${var.environment}/mysql"
}

data "aws_ssm_parameter" "database_subnet" {
  name = "/${var.project}/${var.environment}/database_subnet_ids"
}