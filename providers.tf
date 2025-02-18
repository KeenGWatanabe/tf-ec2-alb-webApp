terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
     version = "5.83.1"
   }
 }
 required_version = ">= 1.1.5"
}

provider "aws" {
  region = var.aws_region
}
