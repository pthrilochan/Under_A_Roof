output "container-name" {
  description = "The name of the container"
  value       = docker_container.nodered_container.name
}

output "ip_address" {
  description = "The IP address of the container"
  //value = [for i in docker_container.nodered_container[*]: i.hostname]
  value = [for i in docker_container.nodered_container[*] : join(":", i.network_data[*]["ip_address"], i.ports[*]["external"])]
  //sensitive = true
}