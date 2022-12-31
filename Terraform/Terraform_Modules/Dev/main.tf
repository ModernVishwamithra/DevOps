# we are passing the values to the variables which we have declared in that particular module
# instead of giving vales directly, we can place them in terraform.tfvars file and pass them as variables

module "network_module" {
  source             = "../modules/network" # this will tell you where to import module
  vpc_cidr           = "10.90.0.0/16"
  vpc_name           = "Ohio-vpc"
  environment        = "Production"
  public_cidr_block  = ["10.90.1.0/24", "10.90.2.0/24", "10.90.3.0/24"]
  private_cidr_block = ["10.90.10.0/24", "10.90.20.0/24", "10.90.30.0/24"]
  azs                = ["us-east-2a", "us-east-2b", "us-east-2c"]
  natgw_id           = module.nat_gw.natgw_id
  owner              = "India-Dev-Team"
}
# we need to use "module" keyword to import/access the output values of another module
module "nat_gw" {
  source           = "../modules/nat_gw"
  public_subnet_id = module.network_module.public_subnets_id_1
  vpc_name         = module.network_module.vpc_name
}
module "sg" {
  source        = "../modules/sg"
  vpc_name      = module.network_module.vpc_name
  environment   = module.network_module.environment
  service_ports = [443, 80, 22, 3389, 445, 8080]
  vpc_id        = module.network_module.vpc_id
}
module "compute" {
  source      = "../modules/compute"
  environment = module.network_module.environment
  amis = {
    us-east-1 = "ami-0574da719dca65348"
  us-east-2 = "ami-0283a57753b18025b" }
  aws_region           = var.aws_region
  instance_type        = "t2.micro"
  key_name             = "msi-keypair"
  public_subnets       = module.network_module.public_subnets_id
  private_subnets      = module.network_module.private_subnets_id
  sg_id                = module.sg.sg_id
  iam_instance_profile = module.iam.instprofile
  vpc_name             = module.network_module.vpc_name
  depends_on = [
    module.elb.elb_listner,
    module.nat_gw.natgw_id
  ]

}

module "iam" {
  source              = "../modules/iam"
  environment         = module.network_module.environment
  rolename            = "devopsb27rolename"
  instanceprofilename = "devopsb27instanceprof"
}
module "elb" {
  source          = "../modules/elb"
  environment     = module.network_module.environment
  nlbname         = "dev-nlb"
  subnets         = module.network_module.public_subnets_id
  tgname          = "dev-nlb-tag"
  vpc_id          = module.network_module.vpc_id
  private_servers = module.compute.private_servers
}

module "route53" {
  source     = "../modules/route53"
  domainname = "pavankumarpacharla.xyz"
  nlb_id     = module.elb.elb_id
  dns_name   = module.elb.elb_dns_name
  zone_id    = module.elb.elb_zone_id
  recordname = "devopsb27"
}



