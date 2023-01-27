resource "aws_vpc" "dev-tf-ansible-integ-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" # gives you an internal domain name
    enable_dns_hostnames = "true" # gives you an internal host name
    #enable_classiclink = false # Argument is deprecated
    instance_tenancy = "default"

    tags = {
        "Name" = "dev-tf-ansible-integ-vpc"
    }
}

resource "aws_subnet" "dev-tf-ansible-integ-public_sub" {
  vpc_id = aws_vpc.dev-tf-ansible-integ-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true" # It makes it a public subnet
  availability_zone = "ap-south-1a"

  tags = {
    "Name" = "dev-tf-ansible-integ-public_sub"
  }
}


