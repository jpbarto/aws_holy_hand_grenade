provider "aws" {}

resource "aws_iam_role" "hhg_role" {
  name = "${var.stack_name}-HHGRole"

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
  name = "${var.stack_name}-hhg-cluster"
}

resource "aws_ecs_task_definition" "hhg_task_def" {
  family = "${var.stack_name}-hhg"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "1024"
  memory = "2048"
  task_role_arn = "${aws_iam_role.hhg_role.arn}"
  execution_role_arn = "${aws_iam_role.hhg_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.stack_name}-hhg-task",
    "image": "jpbarto/hhg:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "environment": [
        {
            "name": "AWS_ACCOUNT_ID",
            "value": "${var.aws_account_id}"
        },
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
