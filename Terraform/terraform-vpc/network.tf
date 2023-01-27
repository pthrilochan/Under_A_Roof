// create an IGW (Internet Gateway)
// It enables your vpc to connect to the internet
resource "aws_internet_gateway" "dev-tf-ansible-integ-igw" {
    vpc_id = aws_vpc.dev-tf-ansible-integ-vpc.id
    
    tags = {
      "Name" = "dev-tf-ansible-integ-igw"
    } 
}

// create a custom route table for public subnet.
// public subnet can reach to the internet by using this.

resource "aws_route_table" "dev-tf-ansible-integ-custom-rt" {
    vpc_id = "${aws_vpc.dev-tf-ansible-integ-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
        gateway_id = "${aws_internet_gateway.dev-tf-ansible-integ-igw.id}"
        //CRT uses this IGW to reach internet
    }

    tags = {
    "Name" = "dev-tf-ansible-integ-custom-rt"
  }
}

# associate crt and subnet

resource "aws_route_table_association" "dev-tf-ansible-integ-custom-rt_association" {
    subnet_id = aws_subnet.dev-tf-ansible-integ-public_sub.id
    route_table_id = aws_route_table.dev-tf-ansible-integ-custom-rt.id
}

# create security group

resource "aws_security_group" "dev-tf-ansible-integ-sg_ssh-allowed" {
  vpc_id = aws_vpc.dev-tf-ansible-integ-vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production. Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }

    //If you do not add this rule, you can not reach the NGIX
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    "Name" = "dev-tf-ansible-integ-sg_ssh-allowed"
  }
  
}
