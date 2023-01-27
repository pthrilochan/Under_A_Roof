# create ec2 instance
resource "aws_instance" "dev-tf-ansible-integ-ec2-web1" {
  ami           = lookup(var.AMI, var.AWS_REGION)
  instance_type = "t2.nano"
  #VPC
  subnet_id = aws_subnet.dev-tf-ansible-integ-public_sub.id
  #Security group
  vpc_security_group_ids = ["${aws_security_group.dev-tf-ansible-integ-sg_ssh-allowed.id}"]
  # The Public SSH key
  key_name = aws_key_pair.dev-tf-ansible-integ-key-pair.id
  tags = {
    "Name" = "dev-tf-ansible-integ-ec2-web1"
  }
}

resource "aws_key_pair" "dev-tf-ansible-integ-key-pair" {
  key_name   = "dev-tf-ansible-integ-key-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}

#IP of aws instance retrieved
output "op1" {
  value = aws_instance.dev-tf-ansible-integ-ec2-web1.public_ip
}


#IP of aws instance copied to a file ip.txt in local system
resource "local_file" "ip" {
  content  = aws_instance.dev-tf-ansible-integ-ec2-web1.public_ip
  filename = "ip.txt"
}

#ebs volume created
resource "aws_ebs_volume" "dev-tf-ansible-integ-ec2-ebs-vol" {
  availability_zone = aws_instance.dev-tf-ansible-integ-ec2-web1.availability_zone
  size              = 1
  tags = {
    Name = "dev-tf-ansible-integ-ec2-ebs-vol"
  }
}

#ebs volume attatched
resource "aws_volume_attachment" "dev-tf-ansible-integ-ec2-ebs-vol_att" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.dev-tf-ansible-integ-ec2-ebs-vol.id
  instance_id  = aws_instance.dev-tf-ansible-integ-ec2-web1.id
  force_detach = true
}

#device name of ebs volume retrieved
output "op2" {
  value = aws_volume_attachment.dev-tf-ansible-integ-ec2-ebs-vol_att.device_name
}


#connecting to the Ansible control node using SSH connection
resource "null_resource" "nullremote1" {
  depends_on = [aws_instance.dev-tf-ansible-integ-ec2-web1]
  connection {
    type     = "ssh"
    user     = "root"
    password = var.password
    host     = var.host
  }
  #copying the ip.txt file to the Ansible control node from local system
  provisioner "file" {
    source      = "ip.txt"
    destination = "/root/ansible_terraform/aws_instance/ip.txt"
  }
}

#connecting to the Linux OS having the Ansible playbook
resource "null_resource" "nullremote2" {
  depends_on = [aws_volume_attachment.dev-tf-ansible-integ-ec2-ebs-vol_att]
  connection {
    type     = "ssh"
    user     = "root"
    password = var.password
    host     = var.host
  }

  #command to run ansible playbook on remote Linux OS
  provisioner "remote-exec" {

    inline = [
      "cd /root/ansible_terraform/aws_instance/",
      "ansible-playbook instance.yml"
    ]
  }
}

# to automatically open the webpage on local system
resource "null_resource" "nullremote3" {
  depends_on = [null_resource.nullremote2]
  provisioner "local-exec" {
    command = "chrome http://${aws_instance.dev-tf-ansible-integ-ec2-web1.public_ip}/web/"
  }
}
