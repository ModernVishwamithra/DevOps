resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.testvpc1.id
  cidr_block = "10.1.1.0/28"

  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.testvpc1.id
  cidr_block = "10.1.2.0/28"

  tags = {
    Name = "public-subnet-2"
  }
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.testvpc1.id
  cidr_block = "10.1.3.0/28"

  tags = {
    Name = "public-subnet-3"
  }
}