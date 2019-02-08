provider "aws" {}

resource "aws_iam_role" "hhg_role" {
  name = "HHGRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
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
resource "aws_ecs_cluster" "hhg_cluster" {
  name = "hhg-cluster"
}

resource "aws_ecs_task_definition" "hhg_task_def" {
  family = "hhg"

  container_definitions = <<DEFINITION
[
  {
    "name": "hgg-task",
    "image": "mongo:latest",
    "cpu": 1024,
    "memory": 2048,
    "taskRoleArn": "${aws_iam_role.hhg_role.arn}",
    "executionRoleArn": "${aws_iam_role.hhg_role.arn}",
    "essential": true,
    "environment": [
        {
            "name": "AWS_ACCOUNT_NAME",
            "value": "${var.aws_account_name}"
        },
        {
            "name": "ECS_CLUSTER_ARN",
            "value": "${aws_ecs_cluster.hhg_cluster.arn}"
        }
    ]
  }
]
DEFINITION
}
