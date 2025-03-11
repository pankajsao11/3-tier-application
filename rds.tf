# launch an rds instance in primary region
resource "aws_db_instance" "my_app_db" {
  allocated_storage    = 15
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.m5d.large"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

# create database subnet group for primary region
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "pr-db-subnet"
  subnet_ids  = [aws_subnet.database.id]
  description = "subnets for Primary database instance"

  tags = {
    Name = "pr-db-subnet"
  }
}

# launch an rds instance in secondary region
resource "aws_db_instance" "my_app_srdb" {
  allocated_storage    = 15
  db_name              = "${var.db_name}-sr"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.m5d.large"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

# create database subnet group for Secondary region
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "sr-db-subnet"
  subnet_ids  = [aws_subnet.database_sr.id]
  description = "subnets for Secondary database instance"

  tags = {
    Name = "sr-db-subnet"
  }
}