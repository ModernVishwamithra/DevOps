data "aws_secretsmanager_secret_version" "creds1" {
  # Fill in the name you gave to your secret
  secret_id = "db-creds"
}