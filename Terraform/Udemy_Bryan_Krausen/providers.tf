terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
  aliases = {
    us = "us-east-1"
    eu = "eu-west-1"
    ap = "ap-south-1"
  }
}