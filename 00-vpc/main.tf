module "vpc" {
  source = "../../vpc-module"
  public_subnet_cidr_block = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  database_subnet_cidr_block = var.database_subnet_cidr_block
  project = var.project
  environment = var.environment
  
  is_peering_required = true
}