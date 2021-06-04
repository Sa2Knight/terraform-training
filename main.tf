provider "aws" {
  region = "ap-northeast-1"
  version = "2.20.0"
}

module "web_server" {
  source = "./http_server"
  instance_type = "t2.micro"
  vpc_id = aws_vpc.my_vpc.id
  subnet_id = aws_subnet.my_subnet.id
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