output "imported_vpc_id" {
    value = data.terraform_remote_state.state_import.outputs.VPC_ID
    sensitive = false
}

output "imported_vpc_arn" {
  value = data.terraform_remote_state.state_import.outputs.VPC_ARN
  sensitive = false
}

output "subnet-1_id" {
  value = data.terraform_remote_state.state_import.outputs.subnet-1_id
  sensitive = false
}

output "subnet-2_id" {
  value = data.terraform_remote_state.state_import.outputs.subnet-2_id
  sensitive = false
}

output "subnet-3_id" {
  value = data.terraform_remote_state.state_import.outputs.subnet-3_id
  sensitive = false
}

output "sg_id" {
  value = data.terraform_remote_state.state_import.outputs.sg_id
  sensitive = false
}
