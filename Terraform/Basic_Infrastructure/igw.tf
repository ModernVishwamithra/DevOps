resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.testvpc1.id

  tags = {
    Name = var.igw_name
  }
}