resource "aws_s3_bucket" "devops-b27-s3-using-count" {
  count = 3
  bucket = "devops-b27-s3-using-count-0${count.index+1}"
  tags = {
    "Name" = "devops-b27-s3-using-count-${count.index+1}"
  }
}
locals {
  standard_tags = {
    name_1 = "devops-b27-s3-using-foreach-1"
    name_2 = "devops-b27-s3-using-foreach-2"
    name_3 = "devops-b27-s3-using-foreach-3"
  }
}

resource "aws_s3_bucket" "devops-b27-s3-using-foreach" {
  for_each = local.standard_tags
  bucket = each.value
  tags = {
    "Name" = each.value
  }
}