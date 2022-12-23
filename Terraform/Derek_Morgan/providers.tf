terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  shared_config_files      = ["/home/thril/.aws/config"]
  shared_credentials_files = ["/home/thril/.aws/credentials"]
  #profile                  = "tfadmin"
}