resource "aws_s3_bucket" "devopsb27-bucket" {
  bucket = "devopsb27-bucket"

  tags = {
    Name        = "Devopsb27-Bucket"
    Environment = var.env
  }
#   depends_on = [
#     aws_s3_bucket.devopsb27-bucket-2
#   ]
}
# resource "aws_s3_bucket" "devopsb27-bucket-2" {
#   bucket = "devopsb27-bucket-2"

#   tags = {
#     Name        = "Devopsb27-Bucket"
#     Environment = var.env
#   }
#   depends_on = [
#     aws_s3_bucket.devopsb27-bucket-3
#   ]
# }
# resource "aws_s3_bucket" "devopsb27-bucket-3" {
#   bucket = "devopsb27-bucket-3"

#   tags = {
#     Name        = "Devopsb27-Bucket"
#     Environment = var.env
#   }
#   depends_on = [
#     aws_s3_bucket.devopsb27-bucket-4
#   ]
# }
# resource "aws_s3_bucket" "devopsb27-bucket-4" {
#   bucket = "devopsb27-bucket-4"

#   tags = {
#     Name        = "Devopsb27-Bucket"
#     Environment = var.env
#   }
# }
