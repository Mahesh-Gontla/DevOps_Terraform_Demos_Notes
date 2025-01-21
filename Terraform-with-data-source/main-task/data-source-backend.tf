data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-0e36c764a34271f61"
}


data "aws_subnet" "Terraform_Public_Subnet1-testing" {
  id = "subnet-08e8f7f330d0e99d6"
}

data "aws_security_group" "allow_all" {
  id = "sg-06c58a3b597cc9acf"
}
