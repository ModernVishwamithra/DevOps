aws_region          = "us-east-2"
vpc_cidr            = "10.2.0.0/16"
public_subnet1_cidr = "10.2.1.0/24"
public_subnet2_cidr = "10.2.2.0/24"
public_subnet3_cidr = "10.2.3.0/24"
private_subnet_cidr = "10.2.20.0/24"
vpc_name            = "terraform-aws-testing"
IGW_name            = "terraform-aws-igw"
public_subnet1_name = "Terraform_Public_Subnet1-testing"
public_subnet2_name = "Terraform_Public_Subnet2-testing"
public_subnet3_name = "Terraform_Public_Subnet3-testing"
private_subnet_name = "Terraform_Private_Subnet-testing"
Main_Routing_Table  = "Terraform_Main_table-testing"
key_name            = "msi-keypair"
environment         = "dev"
imagename           = "ami-02ae910d3317bfe96"