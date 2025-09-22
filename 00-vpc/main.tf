module "vpc" {
  source = "git::https://github.com/ShivanathBabu/terraform-vpc-module.git?ref=main"
  public_subnet_cidr_block = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  database_subnet_cidr_block = var.database_subnet_cidr_block
  project = var.project
  environment = var.environment
  
  is_peering_required = true
}