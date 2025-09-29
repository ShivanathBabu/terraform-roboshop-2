module "frontend" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = var.sg_name
  sg_description = var.sg_description
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "baistion" {
    source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = var.bastion_name
  sg_description = var.bastion_description
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "backen_alb" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = "backend-alb"
  sg_description = "for backend-alb"
  vpc_id = local.vpc_id
}

module "vpn" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = "vpn"
  sg_description = "vpn"
  vpc_id = local.vpc_id
}

module "mongodb" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "mongodb"
  sg_description = "mongodb-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "redis" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "redis"
  sg_description = "redis-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "rabbitmq" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "rabbitmq"
  sg_description = "rabbitmq-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "mysql" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "mysql"
  sg_description = "mysql-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id

}

module "catalogue" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "catalogue"
  sg_description = "catalogue-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "user" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "user"
  sg_description = "user-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "cart" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "cart"
  sg_description = "cart-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "shipping" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "shipping"
  sg_description = "shipping-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "payment" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "payment"
  sg_description = "payment-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "frontend_alb" {
  source = "git::https://github.com/ShivanathBabu/sg-module.git?ref=main"
  sg_name = "frontend_alb"
  sg_description = "frontend_alb-sg"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}





#frontend_alb

resource "aws_security_group_rule" "frontend_alb_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backen_alb.sg_id
}

# frontend

resource "aws_security_group_rule" "frontend_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backen_alb.sg_id
}



# bastion accepting connections from laptop

resource "aws_security_group_rule" "bastion_laptop" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.baistion.sg_id
}

# allowing port 80 connection from bastion sg id to alb

resource "aws_security_group_rule" "backend_alb_bastion" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.backen_alb.sg_id
}

#allowing port no 22 t0 connect mongodb through vpn

resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_ports)
  type = "ingress"
  from_port = var.mongodb_ports[count.index]
  to_port = var.mongodb_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

# reddis sg rules

resource "aws_security_group_rule" "reddis" {
  count = length(var.redis_ports)
  type = "ingress"
  from_port = var.redis_ports[count.index]
  to_port = var.redis_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
}

# rabbitmq

resource "aws_security_group_rule" "rabbitmq" {
  count = length(var.rabbitmq_ports)
  type = "ingress"
  from_port = var.rabbitmq_ports[count.index]
  to_port = var.rabbitmq_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}

# mysql

resource "aws_security_group_rule" "mysql" {
  count = length(var.mysql_ports)
  type = "ingress"
  from_port = var.mysql_ports[count.index]
  to_port = var.mysql_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}


# vpn 
resource "aws_security_group_rule" "vpn_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type = "ingress"
  from_port = 1194
  to_port = 1194
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type = "ingress"
  from_port = 943
  to_port = 943
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# backend-alb

resource "aws_security_group_rule" "backend_alb_vpn" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"  
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backen_alb.sg_id
}

# catalogue

resource "aws_security_group_rule" "catalogue_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backen_alb.sg_id
  security_group_id = module.catalogue.sg_id
}



# vpn 22 to catalogue

resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_bastion" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_mongodb" {
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
}

# user to backend

resource "aws_security_group_rule" "user_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backen_alb.sg_id
  security_group_id = module.user.sg_id
}
#ssh
resource "aws_security_group_rule" "user_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}

# user to mongodb
resource "aws_security_group_rule" "user_mongodb" {
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.mongodb.sg_id
}

# user to redis

resource "aws_security_group_rule" "user_redis" {
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id
}


# alb to cart
resource "aws_security_group_rule" "cart_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backen_alb.sg_id
  security_group_id = module.cart.sg_id
}
# cart ssh
resource "aws_security_group_rule" "cart_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}

# cart to redis

resource "aws_security_group_rule" "cart_redis" {
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.redis.sg_id
}

# alb to shipping
resource "aws_security_group_rule" "shipping_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backen_alb.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}


# shipping to mysql
resource "aws_security_group_rule" "shipping_mysql" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.mysql.sg_id
}

# alb to payment

resource "aws_security_group_rule" "payment_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backen_alb.sg_id
  security_group_id = module.payment.sg_id
}

# payment ssh

resource "aws_security_group_rule" "payment_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

# payment to rabbitmq

resource "aws_security_group_rule" "payment_rabbitmq" {
  type = "ingress"
  from_port = 5672
  to_port = 5672
  protocol = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.rabbitmq.sg_id
}

# bastion

resource "aws_security_group_rule" "mongodb_bastion" {
  count = length(var.mongodb_ports)
  type = "ingress"
  from_port = var.mongodb_ports[count.index]
  to_port = var.mongodb_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "redis_bastion" {
  count = length(var.redis_ports)
  type = "ingress"
  from_port = var.redis_ports[count.index]
  to_port = var.redis_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "rabbitmq_bastion" {
  count = length(var.rabbitmq_ports)
  type = "ingress"
  from_port = var.rabbitmq_ports[count.index]
  to_port = var.rabbitmq_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "mysql_bastion" {
  count = length(var.mysql_ports)
  type = "ingress"
  from_port = var.mysql_ports[count.index]
  to_port = var.mysql_ports[count.index]
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.mysql.sg_id
}

# bastion component

resource "aws_security_group_rule" "bastion_user" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "bastion_cart" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "bastion_shipping" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "bastion_payment" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.baistion.sg_id
  security_group_id = module.payment.sg_id
}