vpc_name                     = "Ohio-vpc"
cidr_block_vpc               = "192.168.0.0/16"
cidr_subnets_block_public    = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24", "192.168.4.0/24"] #instead of giving similar cidr blocks seperately, we can give in the form of list
cidr_subnets_block_private   = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
availability_zones_us_east_2 = ["us-east-2a", "us-east-2b", "us-east-2c"]
key_pair                     = "msi-keypair"
instance_type                = "t2.micro"
region                       = "us-east-2"
environment                  = "Dev"