terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  # Configuration options
}

provider "docker" {}

# Generate random string
resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

# download nodered image

resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace]

}

# Create docker container 
resource "docker_container" "nodered_container" {
  image = docker_image.nodered_image.image_id
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])

  ports {
    internal = var.internal_port
    external = var.external_port[terraform.workspace][count.index]
  }

  volumes {
    container_path = "/data"
    host_path      = pathexpand("~/docker_vol/noderedvol/")
  }
}

# Creating docker volume
resource "null_resource" "docker_vol" {
  provisioner "local-exec" {
    command = "mkdir -p /home/thril/docker_vol/noderedvol/ && chown -R 1000:1000 /home/thril/docker_vol/noderedvol/"
  }
}



