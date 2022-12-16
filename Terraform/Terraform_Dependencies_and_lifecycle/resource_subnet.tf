resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.testvpc1.id
  cidr_block = "10.1.10.0/24"
  tags = {
    Name = "Public-subnet-1"
  }
}