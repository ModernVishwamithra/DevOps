resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.Ohio-vpc.id
  cidr_block        = var.cidr_public_subnet_1
  availability_zone = "us-east-2a"
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.Ohio-vpc.id
  cidr_block        = var.cidr_public_subnet_2
  availability_zone = "us-east-2b"
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id            = aws_vpc.Ohio-vpc.id
  cidr_block        = var.cidr_public_subnet_3
  availability_zone = "us-east-2c"
}