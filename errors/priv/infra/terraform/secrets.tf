###### ARNs for secrets stored in AWS Secrets Manager

data "aws_secretsmanager_secret_version" "secret_key_base" {
  secret_id = var.secret_key_base_arn
}
data "aws_secretsmanager_secret_version" "db_user" {
  secret_id = var.db_user_arn
}
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_arn
}
data "aws_secretsmanager_secret_version" "send_grid_api_key" {
  secret_id = var.send_grid_api_key_arn
}
