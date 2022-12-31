# for creating password for RDS there are contraints
# Constraints: At least 8 printable ASCII characters. 
# Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign).
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Creating a AWS secret for database master account (Masteraccoundb)

resource "aws_secretsmanager_secret" "secretmasterDB" {
  name = "Masteraccountdb"
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
   {
    "username": "pavan",
    "password": "${random_password.password.result}"
   }
EOF
}

# Importing the AWS secrets created previously using arn.

data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.secretmasterDB.arn
}

# # Importing the AWS secret version created previously using arn.

data "aws_secretsmanager_secret_version" "creds2" {
  secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn
}
