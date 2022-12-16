terraform {
  backend "s3" {
    bucket         = "hyderabad-s3"
    key            = "import-cloudformation-devopsb27.tfstate"
    region         = "us-east-2"
    dynamodb_table = "dynamodb-state-locking"
    encrypt        = true
  }
}