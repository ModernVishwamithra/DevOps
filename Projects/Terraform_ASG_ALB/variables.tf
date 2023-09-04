variable "instance_profile_name" {
  type    = string
  default = "terraform-instance-profile"
}

variable "iam_policy_name" {
  type    = string
  default = "assume-role-policy-terrafrom"
}

variable "role_name" {
  type    = string
  default = "ASG_ELB_Role"
}