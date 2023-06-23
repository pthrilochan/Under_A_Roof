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