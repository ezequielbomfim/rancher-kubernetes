module "network" {
  source = "./modules/network"

  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_name      = var.public_subnet_name
  public_subnet_cidr      = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  internet_gateway_name   = var.internet_gateway_name
  public_route_table_name = var.public_route_table_name
}

module "security" {
  source = "./modules/security"

  vpc_id                     = module.network.vpc_id
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  ssh_ingress_cidrs          = var.ssh_ingress_cidrs
}

module "compute" {
  source = "./modules/compute"

  subnet_id             = module.network.public_subnet_id
  security_group_id     = module.security.security_group_id
  key_pair_name         = var.key_pair_name
  instance_type         = var.instance_type
  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  delete_on_termination = var.delete_on_termination
  instance_names        = var.instance_names
  ami_ssm_parameter     = var.ami_ssm_parameter
}
