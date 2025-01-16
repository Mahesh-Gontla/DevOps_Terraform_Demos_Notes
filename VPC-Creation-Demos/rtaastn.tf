resource "aws_route_table_association" "MyRTASST" {
  subnet_id      = aws_subnet.MyPublicSubnet.id
  route_table_id = aws_route_table.MyRTPS.id
}
