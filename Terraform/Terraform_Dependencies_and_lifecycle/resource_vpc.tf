resource "aws_vpc" "testvpc1" {
  cidr_block           = var.cidr_block_vpc1 //old way of giving variables
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "testvpc1"
    Owner       = "Pavan"
    Environment = var.env
  }
   depends_on = [
    aws_s3_bucket.devopsb27-bucket
  ]
}

resource "aws_flow_log" "example" {
  log_destination      = aws_s3_bucket.devopsb27-bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.testvpc1.id

}