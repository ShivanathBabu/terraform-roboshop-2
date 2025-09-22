variable "sg_name" {
  default = "allow-all"
}

variable "sg_description" {
  default = "allow-all-connections"
}

variable "bastion_name" {
  default = "bastion"
}

variable "bastion_description" {
  default = "created for bastion instance"
}

variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "mongodb_ports" {
  default = ["22", "27017"]
}

variable "redis_ports" {
  default = ["22", "6379"]
}

variable "mysql_ports" {
  default = ["22", "3306"]
}

variable "rabbitmq_ports" {
  default = ["22", "5672"]
}