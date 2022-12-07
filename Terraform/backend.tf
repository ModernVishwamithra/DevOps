terraform {
  backend "s3" {
    bucket = "hyderabad-s3"
    key    = "devopsb27.tfstate"
  }
}
