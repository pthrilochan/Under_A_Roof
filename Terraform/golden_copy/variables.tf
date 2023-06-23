variable "image" {
  type        = map(any)
  description = "Image for container"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "external_port" {
  type = map(any)
  #   sensitive = true
  validation {
    condition     = max(var.external_port["dev"]...) <= 65535 && min(var.external_port["dev"]...) >= 1980
    error_message = "The external port must be in the valid port range 0-65535."
  }

  validation {
    condition     = max(var.external_port["prod"]...) < 1980 && min(var.external_port["prod"]...) >= 1880
    error_message = "The external port must be in the valid port range 0-65535."
  }

}

variable "internal_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.internal_port == 1880
    error_message = "The internal port must be set to 1880."
  }
}

locals {
  container_count = length(var.external_port[terraform.workspace])
}
