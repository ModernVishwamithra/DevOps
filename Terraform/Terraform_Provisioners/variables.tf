variable "vpc_name" {}
variable "cidr_block_vpc" {}
variable "cidr_subnets_block_public" {}
variable "cidr_subnets_block_private" {}
variable "availability_zones_us_east_2" {}
variable "key_pair" {}
variable "instance_type" {}
variable "region" {}
variable "environment" {}
variable "amis" {
  type = map(string)
  default = {
    #ubuntu AMIs
    "us-east-1" = "ami-0574da719dca65348"
    "us-east-2" = "ami-0283a57753b18025b"
  }
} 