provider "aws" {
  region = var.region
  default_tags {
    tags = {
      owner     = "krishna"
      silo      = "devsecops"
      terraform = true
      project   = "learnmodule"
    }
  }
}