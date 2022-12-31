terraform {
  required_version = "1.3.6" # this is the terraform version to be used , we are forcing to use this
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # this is the aws version to be used 
    }
  }
}

