provider "aws" {
  region = var.aws_region #"${aws_region-old version}"
}

variable "aws_region" {}

variable "vpc_cidr_block" {}

variable "vpc_tag" {}

variable "subnet_cidr_block" {}

variable "subent_az" {}

variable "subnet_tag" {}

variable "igw_tag" {}

variable "rt_cidr_block" {}

variable "rt_tag" {}

variable "sg_tag" {}

variable "ec2_az" {}

variable "ec2_instance_type" {}

variable "key_name" {}

aws_region = "ap-south-1"

vpc_cidr_block = "10.0.0.0/16"

vpc_tag = "MyVPC-Using-TF"

subnet_cidr_block = "10.0.1.0/24"

subent_az = "ap-south-1a"

subnet_tag = "MyPublic-Subnet-Using-TF"

igw_tag = "MyIGW-Using-TF"

rt_cidr_block = "0.0.0.0/0"

rt_tag = "MyPubli-RT-Using-TF"

sg_tag = "MySG-Using-TF-Allow-All"

ec2_az = "ap-south-1a"

ec2_instance_type = "t2.micro"

key_name = "DevOps-TerraformPractice"

resource "aws_vpc" "MyVPC-Using-TF" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_tag
    Service = "Terraform"
  }
}

resource "aws_subnet" "MyPublic-Subnet-Using-TF" {
  vpc_id                  = aws_vpc.MyVPC-Using-TF.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.subent_az

  tags = {
    Name    = var.subnet_tag
    Service = "Terraform"
  }
}

resource "aws_internet_gateway" "MyIGW-Using-TF" {
  vpc_id = aws_vpc.MyVPC-Using-TF.id

  tags = {
    Name    = var.igw_tag
    Service = "Terraform"
  }
}

resource "aws_route_table" "MyPubli-RT-Using-TF" {
  vpc_id = aws_vpc.MyVPC-Using-TF.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.MyIGW-Using-TF.id
  }

  tags = {
    Name    = var.rt_tag
    Service = "Terraform"
  }
}

resource "aws_route_table_association" "Mypublic-RT-ASCTN-Using-TF" {
  subnet_id      = aws_subnet.MyPublic-Subnet-Using-TF.id
  route_table_id = aws_route_table.MyPubli-RT-Using-TF.id
}

resource "aws_security_group" "MySG-Using-TF-Allow-All" {
  vpc_id = aws_vpc.MyVPC-Using-TF.id

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = var.sg_tag
    Service = "Terraform"
  }
}

resource "aws_instance" "MyEC2-Using-TF" {
  ami                         = "ami-00bb6a80f01f03502"
  availability_zone           = var.ec2_az
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.MyPublic-Subnet-Using-TF.id
  vpc_security_group_ids      = ["${aws_security_group.MySG-Using-TF-Allow-All.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Dev-Server"
    Env        = "Dev"
    Owner      = "MaheshGontla"
    CostCenter = "AWS-Cost"
  }
  
}

resource "aws_s3_bucket" "mys3-bucket-demo-0001" {
  bucket = "mys3-bucket-demo-0001"

  tags = {
    Name        = "mys3-bucket-demo-0001"
    Environment = "Dev"
  }
  depends_on = [ aws_instance.MyEC2-Using-TF ]
}

resource "aws_s3_bucket" "mys3-bucket-demo-0002" {
  bucket = "mys3-bucket-demo-0002"

  tags = {
    Name        = "mys3-bucket-demo-0002"
    Environment = "Dev"
  }
  depends_on = [ aws_s3_bucket.mys3-bucket-demo-0001 ]
  
}

resource "aws_s3_bucket" "mys3-bucket-demo-0003" {
  bucket = "mys3-bucket-demo-0003"

  tags = {
    Name        = "mys3-bucket-demo-0003"
    Environment = "Dev"
  }
  depends_on = [ aws_s3_bucket.mys3-bucket-demo-0002 ]
}
