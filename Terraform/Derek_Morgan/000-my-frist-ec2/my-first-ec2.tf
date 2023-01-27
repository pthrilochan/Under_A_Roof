#defining the provider block
provider "aws" {
  region = "ap-south-1"
  profile = "default"
  
}

# Creating new ec2 instance

resource "aws_instance" "tf-and-ansible_ec2" {
  ami             = "ami-093613b5938a7e47c"
  instance_type   = "t2.micro"
  security_groups = ["sg-0e9f34dfea239e61e"]
  key_name        = "mykey1122"
  tags = {
    Name = "tf-and-ansible-ec2"
  }
}

# EBS volume created

resource "aws_ebs_volume" "tf-and-ansible_vol" {
  availability_zone = aws_instance.tf-and-ansible_ec2.availability_zone
  size              = 1
  tags = {
    "Name" = "ts-and-ansible-ebs"
  }
}

# EBS volume attached to ec2 instance

resource "aws_volume_attachment" "tf-and-ansible_vol-att" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.tf-and-ansible_vol.id
  instance_id  = aws_instance.tf-and-ansible_ec2.id
  force_detach = true
}

/*
# IP of aws instance copied to a file ip.txt in local system

resource "local_file" "IP" {
  content  = aws_instance.tf-and-ansible_ec2.public_ip
  filename = "ip.txt"
}

# Connecting to ansible Control node using SSH connection
resource "null_resource" "nullremote1" {
  depends_on = [
    aws_instance.tf-and-ansible_ec2
  ]
  connection {
    type     = "ssh"
    user     = "root"
    password = var.password
    host     = var.host
  }
  # Copying the ip.txt file to Ansible control node from local system
  provisioner "file" {
    source         = "ip.txt"
    desdestination = "/root/ansible_terraform/aws_instance/ip.txt"
  }
}

*/