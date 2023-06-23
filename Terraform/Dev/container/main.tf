# Create docker container 
resource "docker_container" "nodered_container" {
  image = var.image_in
  name  = var.name_in
  ports {
    internal = var.internal_port_in
    external = var.external_port_in
  }
  volumes {
    container_path = var.container_path_in
    //host_path      = var.host_path_in
    volume_name = docker_volume.container_volume.name
  }
}

resource "docker_volume" "container_volume" {
  name = "${var.name_in}-volume"
}