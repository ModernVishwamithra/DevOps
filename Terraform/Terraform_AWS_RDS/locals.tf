# manually created passoword in secrets manager and we are importing here

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds1.secret_string
  )
}

# Automatically generated password in terraform, saved in secrets manager and we are importing here 

locals {
  db_creds_2 = jsondecode(
    data.aws_secretsmanager_secret_version.creds2.secret_string
  )
}