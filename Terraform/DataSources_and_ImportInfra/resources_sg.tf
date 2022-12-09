resource "aws_security_group" "allow_all_traffic_sg_ohio" {
  name        = "allow_all_sg"
  description = "Allow all traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Inbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_block_default]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_block_default]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all_traffic"
  }
}