###### Environment specific variables that need to be set in terraform.tfvars
variable "app_env" {
  description = "The name of the environment being spun up, i.e. QA, Prod, Dev etc."
}
variable "ecr_image_uri" {
  description = "The URI of the image to run for the environment"
}
variable "db_user_arn" {
  description = "The DB user arn, value is stored in AWS Secrets Manager"
}
variable "db_password_arn" {
  description = "The DB password arn, value is stored in AWS Secrets Manager"
}
variable "secret_key_base_arn" {
  description = "The Phoenix secret"
}
variable "send_grid_api_key_arn" {
  description = "The SendGrid API key"
}

###### Defaults, can be over-ridden in terraform.tfvars if there is a need to
variable "app_name" {
  default     = "guardian"
  description = "The application name"
}
variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region"
}

### VPC
variable "cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR for the VPC"
}
variable "public_subnets" {
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  description = "Public subnets for the VPC"
}
variable "private_subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Private subnets for the VPC"
}
variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b"]
  description = "Availability zones for subnets"
}

### RDS
variable "rds_instance_type" {
  default     = "db.t2.micro"
  description = "RDS instance type to use"
}
variable "rds_encrypt_at_rest" {
  default     = false
  description = "DB encryptiong settings, note t2.micro does not support encryption at rest"
}

### Autoscaling (ECS)
variable "max_instance_size" {
  default     = 2
  description = "Maximum number of instances in the cluster"
}
variable "min_instance_size" {
  default     = 0
  description = "Minimum number of instances in the cluster"
}
variable "desired_capacity" {
  default     = 1
  description = "Desired number of instances in the cluster"
}

### ECS
variable "ecs_ami" {
  default = "ami-0fac5486e4cff37f4" # us-east-1, ami 2
  # Full List: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
}
variable "ecs_instance_type" {
  default     = "t2.micro"
  description = "Instance type to use"
}
variable "key_pair_name" {
  default     = "guardian-prod"
  description = "Key pair to use for ssh access, NOTE: it is assumed this key pair exists, it will not be created!"
}

# Cloudwatch

variable "cloudwatch_group" {
  description = "Couldwatch log group"
}

