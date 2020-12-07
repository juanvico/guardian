locals {
  instance_role_name    = "${var.app_name}-${var.app_env}-ecs-instance-role"
  instance_profile_name = "${var.app_name}-${var.app_env}-ecs-instance-profile"
  service_role_name     = "${var.app_name}-${var.app_env}-ecs-service-role"
}

### ECS EC2 instance role
resource "aws_iam_role" "ecs_instance_role" {
  name               = local.instance_role_name
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = local.instance_profile_name
  path = "/"
  role = aws_iam_role.ecs_instance_role.id
}


### ECS service role
resource "aws_iam_role" "ecs_service_role" {
  name = local.service_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_service_attach" {
  role       = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
