resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  description = "Private subnets for RDS instance"
  subnet_ids = [aws_subnet.private_petsearch_subnet_1, aws_subnet.private_petsearch_subnet_2]

  tags = {
    Name = "rds-subnet-group"
  }
}
resource "aws_db_instance" "rds_instance" {
  identifier              = "petsearch-rds-instance"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = false
  username              = var.db_username
  password              = var.db_password
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {
    Name = "petsearch-rds-instance"
  }
}

