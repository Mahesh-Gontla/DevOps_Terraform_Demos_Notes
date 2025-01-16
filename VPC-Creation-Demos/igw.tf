resource "aws_internet_gateway" "MyIGWUsingTF" {
  vpc_id = aws_vpc.MyVPCUsingTF.id

  tags = {
    Name = "MyIGWUsingTF"
  }
}
