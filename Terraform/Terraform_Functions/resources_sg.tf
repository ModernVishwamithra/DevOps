# resource "aws_security_group" "allow_traffic_sg" {
#   name        = "allow_sg"
#   description = "Allow traffic"
#   vpc_id      = aws_vpc.ohio-vpc.id

#   ingress {
#     description = "Allow SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "SSH"
#     cidr_blocks = ["0.0.0.0/0"]
#     #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }
#    ingress {
#     description = "Allow Database"
#     from_port   = 1377
#     to_port     = 1377
#     protocol    = "TCP"
#     cidr_blocks = ["192.168.2.100/32"]
#     #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }
#      ingress {
#     description = "Allow NLB"
#     from_port   = 3422
#     to_port     = 3422
#     protocol    = "TCP"
#     cidr_blocks = ["192.168.3.100/32"]
#     #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     #ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "Allow_All"
#   }

# If we observe the above SG, multiple ports needs to be allowed. Here code duplicate occured
# Hence, we can simplify this using "dynamic blocks and for_each commands" 
locals {
  ingress = [30, 55, 22, 1344, 3568]
  egress  = [30, 55]
}
resource "aws_security_group" "allow_traffic_sg" {
  name        = "allow_sg"
  description = "Allow traffic"
  vpc_id      = aws_vpc.ohio-vpc.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  dynamic "egress" {
    for_each = local.egress
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }


  }
  tags = {
    Name = "Allow_All"
  }
}
