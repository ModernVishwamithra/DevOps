variable "env" {}
variable "cidr_block_vpc" {}
# variable "cidr_subnet_public1"{}
# variable "cidr_subnet_public2"{}
# variable "cidr_subnet_public3"{}
variable "cidr_subnets_block_public" {} #instead of giving similar cidr blocks seperately, we can give in the form of list
variable "cidr_subnets_block_private" {}
variable "availability_zones_us_east_2" {}
variable "key_pair" {}
variable "instance_type" {}
variable "region" {}
variable "amis" {
  type = map(string)
  default = {
    "us-east-1" = "ami-0b0dcb5067f052a63"
    "us-east-2" = "ami-0beaa649c482330f7"
  }

}