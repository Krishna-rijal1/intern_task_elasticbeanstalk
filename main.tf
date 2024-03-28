module "vpc" {
  source = "./Modules/vpc"
}

module "Ebs" {
  source     = "./Modules/Ebs"
  vpc_id     = module.vpc.vpc_id
  subnet1_id = module.vpc.subnet1_id
  # changes on modules
}