module "networking" {
  source = "./modules/networking"
}

module "iam" {
  source = "./modules/iam"
}

module "compute" {
  source               = "./modules/compute"
  vpc_id               = module.networking.vpc_id
  subnet_id            = module.networking.private_subnet_ids[0]
  iam_instance_profile = module.iam.iam_instance_profile
  cidr_block           = module.networking.vpc_cidr_block
}