resource "aws_eip" "elastic-ip" {
  tags = {
    Name = "Elastic IP"
  }
}

resource "aws_nat_gateway" "ohio-nat-gw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.ohio-public-subnets.0.id

  tags = {
    Name = "Ohio NAT GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ohio-igw]
}