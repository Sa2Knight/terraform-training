provider "aws" {
  region = "ap-northeast-1"
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"

  tags = {
    Name = "terraform-subnet"
  }
}

resource "aws_security_group" "my_security_group" {
  name = "terraform-security-group"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description      = "allow http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = <<EOF
    #! /bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}

output "instance_id" {
  value = aws_instance.my_instance.id
}

output "instance_public_dns" {
  value = aws_instance.my_instance.public_dns
}