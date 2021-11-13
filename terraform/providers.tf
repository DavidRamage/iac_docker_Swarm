terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
