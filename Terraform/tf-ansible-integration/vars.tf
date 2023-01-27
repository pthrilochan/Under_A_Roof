variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "AMI" {
  type = map(any)
  default = {
    #ap-south-1 = "ami-093613b5938a7e47c"
    ap-south-1 = "ami-07ffb2f4d65357b42"
  }
}

variable "PUBLIC_KEY_PATH" {
  default = "/media/sf_Repositories/dev-tf-ansible-integ-key-pair.pub"
}

variable "PRIVATE_KEY_PATH" {
  default = "/media/sf_Repositories/dev-tf-ansible-integ-key-pair"
}

variable "EC2_USER" {
  default = "ubuntu"
}

variable "password" {
  type = string
}
variable "host" {
}
