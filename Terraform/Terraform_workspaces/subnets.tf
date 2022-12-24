resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.testvpc.id
  cidr_block = var.cidr_block_public-subnet-1
  tags = {
    Name = var.public-subnet-1-name
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.testvpc.id
  cidr_block = var.cidr_block_public-subnet-2
  tags = {
    Name = var.public-subnet-2-name
  }
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.testvpc.id
  cidr_block = var.cidr_block_public-subnet-3
  tags = {
    Name = var.public-subnet-3-name
  }
}