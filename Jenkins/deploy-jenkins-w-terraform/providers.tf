terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = var.aws_region
}