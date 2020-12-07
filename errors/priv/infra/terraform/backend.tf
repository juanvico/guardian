# for now don't bother with a backend config
# but if using a backend config, create the bucket manually on AWS
#   - use all the defaults (bucket and objects not  public)
# terraform {
#   backend "s3" {
#     bucket = "my-terraform-state-bucket-for-my-app"
#     key = "aws-warehouse/qa"
#     region = "us-east-1"
#     encrypt = true
#   }
# }
