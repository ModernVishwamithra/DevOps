data "terraform_remote_state" "state_import" {
  backend = "s3"

  config = {
   bucket = "hyderabad-s3"
    key    = "devopsb27.tfstate"
    region         = "us-east-2"
  }
}

# # Terraform >= 0.12
# resource "aws_instance" "foo" {
#   # ...
#   subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
# }

# # Terraform <= 0.11
# resource "aws_instance" "foo" {
#   # ...
#   subnet_id = "${data.terraform_remote_state.vpc.subnet_id}"
# }
