provider "aws" {
  region = "ap-northeast-1"
  version = "2.20.0"
}

variable "instance_type" { }
variable "vpc_id" {}
variable "subnet_id" {}

resource "aws_instance" "default" {
  ami           = "ami-0c3fd0f5d33134a76"
  vpc_security_group_ids = [aws_security_group.default.id]
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true

  user_data = <<EOF
    #! /bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}

resource "aws_security_group" "default" {
  name = "ec2"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "public_dns" {
  value = aws_instance.default.public_dns
}