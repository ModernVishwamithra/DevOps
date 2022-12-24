output "VPC_ID" {
  value = aws_vpc.testvpc1.id
  sensitive = false
}

output "VPC_ARN" {
  value = aws_vpc.testvpc1.arn
  sensitive = false
}

output "subnet-1" {
  value = aws_subnet.public-subnet-1.id
  sensitive = false
}

output "subnet-2" {
  value = aws_subnet.public-subnet-2.id
  sensitive = false
}

output "subnet-3" {
  value = aws_subnet.public-subnet-3.id
  sensitive = false
}
