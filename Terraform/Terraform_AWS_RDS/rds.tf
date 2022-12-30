resource "aws_db_instance" "example-rds-1" {
  allocated_storage    = 10
  db_name              = "mydb1"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.medium"
  username             = local.db_creds.username
  password             = local.db_creds.password
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  skip_final_snapshot  = true
  publicly_accessible = true
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "main"
  subnet_ids = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "example-rds-2" {
  allocated_storage    = 10
  db_name              = "mydb2"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.medium"
  username             = local.db_creds_2.username
  password             = local.db_creds_2.password
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  skip_final_snapshot = true
  publicly_accessible = true
}