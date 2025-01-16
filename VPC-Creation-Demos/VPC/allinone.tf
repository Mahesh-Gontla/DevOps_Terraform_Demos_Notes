# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "MyVPCUsingTF" {
  cidr_block = "10.0.0.0/16"
  #instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "MyVPCUsingTF"
  }
}

resource "aws_internet_gateway" "MyIGWUsingTF" {
  vpc_id = aws_vpc.MyVPCUsingTF.id

  tags = {
    Name = "MyIGWUsingTF"
  }
}

resource "aws_subnet" "MyPublicSubnet" {
  vpc_id     = aws_vpc.MyVPCUsingTF.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "MyPublicSubnet"
  }
}

resource "aws_route_table" "MyRTPS" {
  vpc_id = aws_vpc.MyVPCUsingTF.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGWUsingTF.id
  }

  tags = {
    Name = "MyRTPS"
  }
}

resource "aws_route_table_association" "MyRTASST" {
  subnet_id      = aws_subnet.MyPublicSubnet.id
  route_table_id = aws_route_table.MyRTPS.id
}

resource "aws_security_group" "MySGUsingTF" {
  name        = "MySGUsingTF"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.MyVPCUsingTF.id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySGUsingTF"
  }
}
