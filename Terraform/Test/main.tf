terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "container_image" {
  name = "grafana/grafana:latest"
}