resource "aws_security_group" "allow_traffic_sg" {
  name        = "allow_sg"
  description = "Allow traffic"
  vpc_id      = aws_vpc.testvpc1.id

  ingress {
    description      = "RDS traffic"
    from_port        = 1520
    to_port          = 1520
    protocol         = "TCP"
    cidr_blocks      = ["10.1.10.23/32"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_traffic"
  }

  lifecycle {
    create_before_destroy = true
    #prevent_destroy = true
    ignore_changes = [
      ingress,
    ]
  }
}