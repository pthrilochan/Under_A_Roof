# Creating new ec2 instance

resource "aws_instance" "tf-practice_ec2" {
  ami             = "ami-093613b5938a7e47c"
  instance_type   = "t2.micro"
  #security_groups = ["sg-0e9f34dfea239e61e"]
  #key_name        = "mykey1122"
  
  tags = {
    Name = "sandbox"
  }
}