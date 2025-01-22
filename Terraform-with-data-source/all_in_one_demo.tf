provider "aws" {
  #access_key = "${var.aws_access_key}"
  #secret_key = "${var.aws_secret_key}"
  region = var.aws_region
}

#variable "aws_access_key" {
#}
#variable "aws_secret_key" {
#}
variable "aws_region" {}
variable "amis" {
  description = "AMIs by region"
  default = {
    ap-south-1 = "ami-00bb6a80f01f03502" # ubuntu 24.04 LTS-mumbai region
    #ap-south-2 = "ami-f63b1193" # ubuntu 14.04 LTS
    #us-east-1 = "ami-824c4ee2" # ubuntu 14.04 LTS
    #us-east-2 = "ami-f2d3638a" # ubuntu 14.04 LTS
  }
}

variable "vpc_cidr" {}
variable "vpc_name" {}
variable "IGW_name" {}
variable "key_name" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "public_subnet3_cidr" {}
#variable "private_subnet_cidr" {}
variable "public_subnet1_name" {}
variable "public_subnet2_name" {}
variable "public_subnet3_name" {}
#variable "private_subnet_name" {}
variable "Main_Routing_Table" {}

variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "environment" { default = "dev" }
variable "instance_type" {
  type = map(string)
  default = {
    dev  = "t2.nano"
    test = "t2.micro"
    prod = "t2.medium"
  }
}

terraform {
  backend "s3" {
    bucket = "myterraform-backend-s3bucket-for-statelocking"
    key    = "Base-Infra.tfstate"
    region = "ap-south-1"
  }
}


resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.vpc_name}"
    Owner = "MaheshGontla"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.IGW_name}"
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

resource "aws_subnet" "subnet2-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}

resource "aws_subnet" "subnet3-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet3_cidr
  availability_zone = "ap-south-1c"

  tags = {
    Name = "${var.public_subnet3_name}"
  }

}

resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = aws_subnet.subnet1-public.id
  route_table_id = aws_route_table.terraform-public.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "dynamodb-state-locking"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}











Data source with remote state
git clone https://github.com/saikiranpi/Terraformsingleinstance.git
main.tf
variable.tf
variable.tfvars
and do the necessary modifications for this repo and without ec2 instance configuration apply the terraform
create a another folder for provision the ec2 instance based on s3 backend state file and the previous provided configuration in the older folder
have to create a bucket for the backend
terraform {
  backend "s3" {
    bucket = "BucketNameavailableinS3"
    key    = "Base-Infra.tfstate"
    region = "us-east-1"
  }
}


https://github.com/saikiranpi/Git-Terra/blob/production/vpc.tf

BaseInfra-->VPC-configuration(all)-->statefile(remote backend store)-->from main-task folder-->gng to create ec2 instance-->using data source as a backend
s3 bucket for storing the ec2 backend
/main-task
ec2.tf
resource "aws_instance" "web-1" {

    ami = "ami-0d857ff0f5fc4e03b"
     availability_zone = "us-east-1a"
     instance_type = "t2.micro"
     key_name = "LaptopKey"
     subnet_id = data.aws_subnet
     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
     associate_public_ip_address = true	
     tags = {
         Name = "Server-1"
         Env = "Prod"
         Owner = "sai"
 	CostCenter = "ABCD"
    }
}
for this also add terraform backend


data-source-backend.tf
-->
data "aws_vpc" "vpc-name-as-above-created"{
    id = "id-of-existing-vpc-as-above-created"
}

data "aws_subnet" "aws_subnet-name-as-above-created"{
    id = "id-of-existing-subnet-as-above-created"
}

data "aws_security_group" "sg-name-as-above-created"{
    id = "id-of-existing-sg-as-above-created"
}
