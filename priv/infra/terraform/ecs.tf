###### ECS

locals {
  cluster_name         = "${var.app_name}-${var.app_env}"
  service_name         = "${var.app_name}-${var.app_env}-service"
  asg_name             = "${var.app_name}-${var.app_env}-asg"
  launch_config_prefix = "${var.app_name}-${var.app_env}"
}

### Cluster
resource "aws_ecs_cluster" "cluster" {
  name = local.cluster_name
}

#### Launch config
resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix          = local.launch_config_prefix
  image_id             = var.ecs_ami
  instance_type        = var.ecs_instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.id

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.appserver_sg.id, aws_security_group.ssh_sg.id]
  associate_public_ip_address = "true"
  key_name                    = var.key_pair_name

  user_data = <<EOF
#!/bin/bash

echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config
EOF
}

### Auto-scaling
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name = local.asg_name
  max_size = var.max_instance_size
  min_size = var.min_instance_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = module.vpc.public_subnets
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name
  health_check_type = "ELB"

  # populate the 'Name' field of the EC2 instance
  tag {
    key = "Name"
    value = local.cluster_name
    propagate_at_launch = true
  }
}

### Task definition
data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.task.family

  depends_on = [aws_ecs_task_definition.task]
}

resource "aws_ecs_task_definition" "task" {
  family = local.cluster_name

  container_definitions = <<CONTAINER
  [
    {
      "cpu": 1024,
      "memory": 983,
      "essential" :true,
      "image": "${var.ecr_image_uri}",
      "name": "${var.app_name}-${var.app_env}",
      "portMappings": [
        {
          "containerPort": 4000,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.cloudwatch_group}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "environment": [
        {
          "name": "SECRET_KEY_BASE",
          "value": "${jsondecode(data.aws_secretsmanager_secret_version.secret_key_base.secret_string)["SECRET_KEY_BASE"]}"
        },
        {
          "name": "DB_HOST",
          "value": "${aws_db_instance.db.address}"
        },
        {
          "name": "DB_INSTANCE",
          "value": "${aws_db_instance.db.name}"
        },
        {
          "name": "DB_USER",
          "value": "${jsondecode(data.aws_secretsmanager_secret_version.db_user.secret_string)["DB_USER"]}"
        },
        {
          "name": "DB_PASSWORD",
          "value": "${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["DB_PASSWORD"]}"
        },
        {
          "name": "SEND_GRID_API_KEY",
          "value": "${jsondecode(data.aws_secretsmanager_secret_version.send_grid_api_key.secret_string)["SEND_GRID_API_KEY"]}"
        }
      ]
    }
  ]
CONTAINER
}

### Service
resource "aws_ecs_service" "service" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${aws_ecs_task_definition.task.family}:${max("${aws_ecs_task_definition.task.revision}", "${data.aws_ecs_task_definition.task.revision}")}"
  desired_count   = 1
  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    container_name   = "${var.app_name}-${var.app_env}"
    container_port   = 4000
  }
  depends_on = [aws_lb.lb]
}
