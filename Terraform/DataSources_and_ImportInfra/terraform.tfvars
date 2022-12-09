# this file is used to declare variables for all the files

#vpc
env = "Dev" 
cidr_block_vpc1 = "10.1.0.0/16" 
cidr_block_vpc2 = "10.2.0.0/16" 
cidr_block_vpc3 = "10.3.0.0/16" 
cidr_block_default = "0.0.0.0/0"

#subnets
cidr_block_public-subnet-1 = "10.1.10.0/24"
cidr_block_public-subnet-2 = "10.1.20.0/24" 
cidr_block_public-subnet-3 = "10.1.30.0/24" 
public-subnet-1-name = "public-subnet-1" 
public-subnet-2-name = "public-subnet-2" 
public-subnet-3-name = "public-subnet-3" 

cidr_block_ohio_public-subnet-1 = "10.4.10.0/24" 
cidr_block_ohio_public-subnet-2 = "10.4.20.0/24" 
#internet-gateway
igw_name = "igw" 

#routing-table
routing_table_name_public = "public-rt" 

#ohio-vpc id for us-est-2
vpc_id = "vpc-02d45212396c56640"
ohio_vpc_name = "ohio-vpc" 
ohio_public_subnet_id = "subnet-0211c095c5613fedf"
ohio_public_route_table_id = "rtb-07f30944da5407661"