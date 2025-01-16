resource "aws_subnet" "MyPublicSubnet" {
  vpc_id     = aws_vpc.MyVPCUsingTF.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "MyPublicSubnet"
  }
}
