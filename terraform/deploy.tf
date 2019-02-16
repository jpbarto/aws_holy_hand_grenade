provider "aws" {}

data "aws_region" "current" {}

resource "aws_iam_role" "hhg_role" {
  name = "${var.stack_name}-HHGRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "ecs-tasks.amazonaws.com",
            "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "hhg_admin_permissions" {
  role       = "${aws_iam_role.hhg_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# hhg ECS cluster
resource "aws_cloudwatch_log_group" "hhg_log_group" {
  name = "/ecs/${var.stack_name}-hhg-output"
}

resource "aws_ecs_cluster" "hhg_cluster" {
  name = "${var.stack_name}-hhg-cluster"
}

resource "aws_ecs_task_definition" "hhg_task_def" {
  family                   = "${var.stack_name}-hhg"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  task_role_arn            = "${aws_iam_role.hhg_role.arn}"
  execution_role_arn       = "${aws_iam_role.hhg_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.stack_name}-hhg-task",
    "image": "jpbarto/aws_holy_hand_grenade:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "environment": [
        {
            "name": "TARGET_AWS_ACCOUNT_NUMBER",
            "value": "${var.aws_account_id}"
        },
        {
            "name": "HHG_ECS_CLUSTER",
            "value": "${aws_ecs_cluster.hhg_cluster.arn}"
        },
        {
            "name": "HHG_LOG_GROUP",
            "value": "/ecs/${var.stack_name}-hhg-output"
        },
        {
          "name": "HHG_IAM_ROLE",
          "value": "${aws_iam_role.hhg_role.name}"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${var.stack_name}-hhg-output",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
DEFINITION
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "pull_the_pin" {
  filename         = "lambda.zip"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${var.stack_name}-PullThePin"
  role             = "${aws_iam_role.hhg_role.arn}"
  description      = "Start the ECS task running to execute AWS-Nuke"
  handler          = "hhg.pull_the_pin"
  runtime          = "python3.6"
  timeout          = 60

  environment = {
    variables = {
      CLUSTER_NAME = "${aws_ecs_cluster.hhg_cluster.name}"
      TASK_DEF_ARN = "${aws_ecs_task_definition.hhg_task_def.arn}"
    }
  }
}
