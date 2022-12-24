terraform {
  backend "s3" {
    bucket = "devopsb27-ohio-s3-bucket"
    key    = "devopsb27dependencies.tfstate"
    # region         = "us-east-2"
    dynamodb_table = "dynamodb-dependencies-tfstate-locking"
    encrypt        = true
  }
}
