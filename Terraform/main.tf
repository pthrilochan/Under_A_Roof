# Generate random string
resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

# download nodered image
module "image" {
  source   = "./Dev/image"
  image_in = var.image[terraform.workspace]
}

# # Creating docker volume
# resource "null_resource" "docker_vol" {
#   provisioner "local-exec" {
#     command = "mkdir -p /home/thril/docker_vol/noderedvol/ && chown -R 1000:1000 /home/thril/docker_vol/noderedvol/"
#   }
# }

# Create docker container 
module "container" {
  source = "./Dev/container"
  //depends_on = [null_resource.docker_vol]
  image_in = module.image.image_out
  /* Any attribute specified after the source attribute i.e. called vaiable.
  so, image_in is a vaiable and becomes available to all child modules */
  count             = local.container_count
  name_in           = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  internal_port_in  = var.internal_port
  external_port_in  = var.external_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in      = pathexpand("~/docker_vol/noderedvol/")
}