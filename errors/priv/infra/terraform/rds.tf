###### RDS

locals {
  identifier = "${var.app_name}-${var.app_env}-db"
  # dashes are not valid database names so replace dashes with underscores
  instance_name     = "${replace(var.app_name, "-", "_")}_${var.app_env}"
  subnet_group_name = "${var.app_name}-${var.app_env}-db-subnet"
}

resource "aws_db_subnet_group" "db_sn" {
  name       = local.subnet_group_name
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "db" {
  identifier              = local.identifier
  name                    = local.instance_name
  username                = jsondecode(data.aws_secretsmanager_secret_version.db_user.secret_string)["DB_USER"]
  password                = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["DB_PASSWORD"]
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "10.6"
  port                    = 5432
  instance_class          = var.rds_instance_type
  backup_retention_period = 7
  publicly_accessible     = false
  storage_encrypted       = var.rds_encrypt_at_rest
  multi_az                = false
  db_subnet_group_name    = aws_db_subnet_group.db_sn.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  tags = {
    Name = local.identifier
  }
}
