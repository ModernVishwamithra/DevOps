resource "aws_internet_gateway" "ohio-igw" {
  vpc_id = aws_vpc.ohio-vpc.id

  tags = {
    Name = "Ohio-igw"
  }
}

