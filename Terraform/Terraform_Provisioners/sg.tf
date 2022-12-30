locals {
    ingress =[0]
  egress = [0]
}
resource "aws_security_group" "sg" {
    name = "Allow-ports-sg"
    description = "Allow Traffic"
  vpc_id = aws_vpc.ohio-vpc.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
    description = "Inbound Traffic"
    from_port = ingress.value
    to_port = ingress.value
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }
#   ingress {
#     description      = "Inbound traffic"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.cidr_block_default]
#     #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }
  dynamic "egress" {
    for_each = local.egress 
    content {
      description = "Outbound Traffic"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.cidr_block_vpc]
    }
  }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.cidr_block_default]
#     #ipv6_cidr_blocks = ["::/0"]
#   }
   tags = {
    Name = "Ogio-SG"
   }
}