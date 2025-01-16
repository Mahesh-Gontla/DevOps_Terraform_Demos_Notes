resource "aws_security_group" "MySGUsingTF" {
  name        = "MySGUsingTF"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.MyVPCUsingTF.id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySGUsingTF"
  }
}
