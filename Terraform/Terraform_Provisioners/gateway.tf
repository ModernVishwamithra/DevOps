resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ohio-vpc.id
  tags = {
    Name = "Ohio-IGW-gw"
  }
}

resource "aws_eip" "eip" {
  tags = {
    Name = "Ohio-nat-gw-EIP"
  }
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.0.id
  tags = {
    Name = "Ohio-nat-gw"
  }
   depends_on = [aws_internet_gateway.igw]
}