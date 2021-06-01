output "instance_id" {
  value = aws_instance.my_instance.id
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

resource "aws_network_interface" "my_network_interface" {
  subnet_id   = aws_subnet.my_subnet.id

  tags = {
    Name = "terraform-network-interface"
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.my_network_interface.id
    device_index         = 0
  }
}