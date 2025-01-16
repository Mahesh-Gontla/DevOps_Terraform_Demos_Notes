# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "Data-Source-VPC-Manual" {
  id = "vpc-03d60b047ee3abb25"
}

resource "aws_internet_gateway" "Data-Source-IGW" {
  vpc_id = data.aws_vpc.Data-Source-VPC-Manual.id

  tags = {
    Name = "Data-Source-IGW"
  }
}


In above we created vpc using terraform
In normally if we create vpc manually(terraform will not capture this state) 
and i want to attach igw using terraform to the manually created vpc
For this we need DataSources in terraform
create a vpc manually and attach the igw using terraform
data-source.tf-->accessing resources created outside terraform
