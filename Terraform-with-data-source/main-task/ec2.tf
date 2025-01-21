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
