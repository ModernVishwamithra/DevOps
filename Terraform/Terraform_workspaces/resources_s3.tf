locals {
  bucket_name_lower = lower("${var.env}-s3-bucket-b27")
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.bucket_name_lower //always bucket name should be lower case

  tags = {
    Name        = "${local.bucket_name_lower}"
    Environment = "Dev"
  }
}
