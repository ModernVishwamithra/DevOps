resource "aws_internet_gateway" "mytestvpc-igw" {
  vpc_id = aws_vpc.mytestvpc01.id
  tags = {
    "Name" = "MyTestVPC-IGW"
  }
}
