resource "aws_batch_compute_environment" "aws_compute" {
  compute_environment_name = "${var.deployment_name}_compute"

  compute_resources {
    max_vcpus = 10000

    security_group_ids = [
      aws_security_group.aws_sec_grp.id
    ]

    subnets = [
      aws_subnet.subnet1.id,
      aws_subnet.subnet2.id
    ]
    type = "FARGATE"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
}

resource "aws_batch_job_queue" "aws_queue" {
  name     = "${var.deployment_name}_queue"
  state    = "ENABLED"
  priority = 1
  compute_environment_order {
    order = 1
    compute_environment = aws_batch_compute_environment.aws_compute.arn
  }
}

resource "aws_batch_job_definition" "aws_jobdef" {
  name                  = "${var.deployment_name}_jobdef"
  type                  = "container"
  platform_capabilities = ["FARGATE"]

  retry_strategy {
    attempts = 3
    evaluate_on_exit {
      on_status_reason = "Essential container in task exited"
      action           = "EXIT"
    }
    evaluate_on_exit {
      on_status_reason = "*"
      action           = "RETRY"
    }
  }
  timeout {
    attempt_duration_seconds = 72000
  }
  depends_on = [aws_iam_role_policy_attachment.ecs_task_exec_role,
    aws_iam_role_policy_attachment.ecs_task_exec_role_s3,
  aws_iam_role_policy_attachment.ecs_task_exec_role_cw]

  container_properties = jsonencode({
    "command" = [],
    "image" : "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.deployment_name}:latest",
    "jobRoleArn" : "${aws_iam_role.ecs_task_exec_role.arn}",
    "executionRoleArn" : "${aws_iam_role.ecs_task_exec_role.arn}",
    "resourceRequirements" : [
      { "type" : "VCPU", "value" : "1" },
      { "type" : "MEMORY", "value" : "2048" }
    ],
    fargatePlatformConfiguration : {
      platformVersion = "LATEST"
    },
    runtimePlatform = {
      operatingSystemFamily = "LINUX"
      cpuArchitecture = "ARM64"
    },
    environment = [
      { "name" : "AWS_REGION", "value" : "" }
    ],
    "networkConfiguration" : {
      "assignPublicIp" : "ENABLED"
    },
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : "batch/${var.deployment_name}"
      }
    }
  })
}
