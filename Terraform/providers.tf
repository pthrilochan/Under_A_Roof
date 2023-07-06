terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
    docker = {
      source  = "registry.terraform.io/kreuzwerker/docker"
      version = "3.0.2"
    }
  
  }
    required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "terraform-in-30-days-remote-state"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-in-30-days-remote-state"
  }
}

# provider "random" {
#   # Configuration options
# }

# provider "aws" {
#   # Configuration options
# }

# provider "docker" {
#   # Configuration options
# }