output "VPC_ID" {
  value = data.aws_vpc.testvpc1.id
  sensitive = false
}

output "VPC_ARN" {
  value = data.aws_vpc.testvpc1.arn
  sensitive = false
}