output "container-name" {
  value       = module.container[*].container-name
  description = "The name of the container"
}

output "ip-address" {
  description = "The IP address of the container"
  //value = [for i in docker_container.nodered_container[*]: i.hostname]
  //value = [for i in docker_container.nodered_container[*] : join(":", i.network_data[*]["ip_address"], i.ports[*]["external"])]
  //sensitive = true
  value = flatten(module.container[*].ip_address)
}