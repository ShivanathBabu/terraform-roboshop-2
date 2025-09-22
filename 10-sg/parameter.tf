resource "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.environment}/frontend_sg_id"
  type = "String"
  value = module.frontend.sg_id
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.environment}/bastion_sg_id"
  type = "String"
  value = module.baistion.sg_id
}

resource "aws_ssm_parameter" "backen_alb" {
  name = "/${var.project}/${var.environment}/backen_alb"
  type = "String"
  value = module.backen_alb.sg_id
}

resource "aws_ssm_parameter" "vpn" {
  name = "/${var.project}/${var.environment}/vpn"
  type = "String"
  value = module.vpn.sg_id
}

resource "aws_ssm_parameter" "mongodb" {
  name = "/${var.project}/${var.environment}/mongodb"
  type = "String"
  value = module.mongodb.sg_id
}

resource "aws_ssm_parameter" "redis" {
  name = "/${var.project}/${var.environment}/redis"
  type = "String"
  value = module.redis.sg_id
}

resource "aws_ssm_parameter" "rabbitmq" {
  name = "/${var.project}/${var.environment}/rabbitmq"
  type = "String"
  value = module.rabbitmq.sg_id
}

resource "aws_ssm_parameter" "mysql" {
  name = "/${var.project}/${var.environment}/mysql"
  type = "String"
  value = module.mysql.sg_id
}

resource "aws_ssm_parameter" "catalogue" {
   name = "/${var.project}/${var.environment}/catalogue"
  type = "String"
  value = module.catalogue.sg_id
}

resource "aws_ssm_parameter" "user" {
  name = "/${var.project}/${var.environment}/user"
  type = "String"
  value = module.user.sg_id
}

resource "aws_ssm_parameter" "cart" {
  name = "/${var.project}/${var.environment}/cart"
  type = "String"
  value = module.cart.sg_id
}

resource "aws_ssm_parameter" "shipping" {
  name = "/${var.project}/${var.environment}/shipping"
  type = "String"
  value = module.shipping.sg_id
}

resource "aws_ssm_parameter" "payment" {
  name = "/${var.project}/${var.environment}/payment"
  type = "String"
  value = module.payment.sg_id
}

resource "aws_ssm_parameter" "frontend_alb" {
  name = "/${var.project}/${var.environment}/frontend_alb"
  type = "String"
  value = module.frontend_alb.sg_id
}

resource "aws_ssm_parameter" "frontend" {
  name = "/${var.project}/${var.environment}/frontend"
  type = "String"
  value = module.frontend.sg_id
}


