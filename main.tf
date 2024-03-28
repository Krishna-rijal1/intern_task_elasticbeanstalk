module "vpc" {
  source = "./modules/vpc"
}

module "Ebs" {
  source     = "./modules/Ebs"
  vpc_id     = module.vpc.vpc_id
  subnet1_id = module.vpc.subnet1_id
}