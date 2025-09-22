locals {
  ami = data.aws_ami.blackweb_agency.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb.value
  mysql_sg_id = data.aws_ssm_parameter.mysql.value
  reddis_sg_id = data.aws_ssm_parameter.reddis.value
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq.value
  subnet = split (",", data.aws_ssm_parameter.database_subnet.value)[0]

  common_tags = {
    project = var.project
    environment = var.environment
  }
}