# Add environment specific variable values to this file, can also optionally
# over-ride defaults if desired

# REQUIRED, ENVIRONMENT SPECIFIC
app_env                   = "prod"
ecr_image_uri             = "198739960305.dkr.ecr.us-east-1.amazonaws.com/guardian:latest"
db_user_arn               = "arn:aws:secretsmanager:us-east-1:198739960305:secret:prod/guardian/db_user-bljaNg"
db_password_arn           = "arn:aws:secretsmanager:us-east-1:198739960305:secret:prod/guardian/db_password-XaX0q0"
secret_key_base_arn       = "arn:aws:secretsmanager:us-east-1:198739960305:secret:prod/guardian/secret_key_base-qQCwHs"
send_grid_api_key_arn     = "arn:aws:secretsmanager:us-east-1:198739960305:secret:prod/guardian/send_grid_api_key-o1XZKy"
cloudwatch_group          = "production-logs"

# OPTIONAL, default over-rides
# nothing to over-ride as of yet
