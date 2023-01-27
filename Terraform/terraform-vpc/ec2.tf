
# create ec2 instance
resource "aws_instance" "dev-tf-ansible-integ-ec2-web1" {
  ami           = "${lookup(var.AMI, var.AWS_REGION)}"
  instance_type = "t2.nano"
  #VPC
  subnet_id = "${aws_subnet.dev-tf-ansible-integ-public_sub.id}"
  #Security group
  vpc_security_group_ids = ["${aws_security_group.dev-tf-ansible-integ-sg_ssh-allowed.id}"]
  # The Public SSH key
  key_name = "${aws_key_pair.dev-tf-ansible-integ-key-pair.id}"
  tags = {
    "Name" = "dev-tf-ansible-integ-ec2-web1"
  }

# nginx installation
  provisioner "file" {
    source = "nginx.sh"
    destination = "/tmp/nginx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
      ]
    }

  connection {
    type = "ssh"
    user        = "${var.EC2_USER}"
    private_key = "${file("${var.PRIVATE_KEY_PATH}")}"
    host = self.public_ip
  }
}

resource "aws_key_pair" "dev-tf-ansible-integ-key-pair" {
  key_name   = "dev-tf-ansible-integ-key-pair"
  public_key = "${file(var.PUBLIC_KEY_PATH)}"
}