provider "aws" {
    #access_key = "${var.aws_access_key}"
    #secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-0e36c764a34271f61"
}


data "aws_subnet" "Terraform_Public_Subnet1-testing" {
  id = "subnet-08e8f7f330d0e99d6"
}

data "aws_security_group" "allow_all" {
  id = "sg-06c58a3b597cc9acf"
}




#Have created VPC already with remote statefile-->Base-Infra
#Want to create ec2 from another folder with remote statefile and have to use the base-infra
#from the above vpc  

resource "aws_instance" "web-1" {
     ami = "ami-00bb6a80f01f03502"
     availability_zone = "ap-south-1a"
     instance_type = "t2.micro"
     key_name = "DevOps-TerraformPractice"
     subnet_id = "${data.aws_subnet.Terraform_Public_Subnet1-testing.id}"
     vpc_security_group_ids = ["${data.aws_security_group.allow_all.id}"]
     associate_public_ip_address = true	
     tags = {
         Name = "Server-1"
         Env = "Dev"
         Owner = "MaheshGontla"
 	 CostCenter = "ABCD"
     }
      #user_data = <<- EOF
      #!/bin/bash
      	#sudo apt-get update
      	#sudo apt-get install -y nginx
      	#echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
      	#sudo systemctl start nginx
      	#sudo systemctl enable nginx
      #EOF

}

terraform {
  backend "s3" {
    bucket = "myterraform-backend-s3bucket-for-statelocking"
    key    = "current-state.tfstate"
    region = "ap-south-1"
  }
}
