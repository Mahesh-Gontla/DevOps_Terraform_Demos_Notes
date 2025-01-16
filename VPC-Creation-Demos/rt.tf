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
