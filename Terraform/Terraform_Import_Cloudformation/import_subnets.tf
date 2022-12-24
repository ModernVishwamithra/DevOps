resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.mytestvpc01.id
  cidr_block        = "10.10.10.0/24"
  availability_zone = "us-east-2b"
  tags = {
    "Name" = "MyTestVPC-Pub-Subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.mytestvpc01.id
  cidr_block        = "10.10.20.0/24"
  availability_zone = "us-east-2b"
  tags = {
    "Name" = "MyTestVPC-Pub-Subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id            = aws_vpc.mytestvpc01.id
  cidr_block        = "10.10.30.0/24"
  availability_zone = "us-east-2a"
  tags = {
    "Name" = "MyTestVPC-Pub-Subnet-3"
  }
}
