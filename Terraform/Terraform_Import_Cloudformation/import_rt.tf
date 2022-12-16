resource "aws_route_table" "MyTestVPC-rt" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0237575f317a48f9c"
  }

  tags = {
    "Name" = "MyTestVPC-MAIN-RT"
  }
  vpc_id = aws_vpc.mytestvpc01.id
}
# resource "aws_route_table" "default-rt" {
#   #   route {
#   #       cidr_block                 = "0.0.0.0/0"
#   #       gateway_id                 = "igw-0237575f317a48f9c"
#   #     }

#   tags = {
#     "Name" = "Default-RT"
#   }
#   vpc_id = aws_vpc.mytestvpc01.id
# }

resource "aws_route_table_association" "public-rt-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.MyTestVPC-rt.id

}

resource "aws_route_table_association" "public-rt-association-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.MyTestVPC-rt.id

}

resource "aws_route_table_association" "public-rt-association-3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.MyTestVPC-rt.id

}