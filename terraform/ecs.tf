# resource "aws_ecs_task_definition" "app" {
#   family                   = var.app_name
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = var.cpu
#   memory                   = var.memory

#   execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

#   container_definitions = jsonencode([
#     {
#       name  = var.app_name
#       image = "${aws_ecr_repository.app_repo.repository_url}:latest"

#       portMappings = [
#         {
#           containerPort = var.container_port
#           hostPort      = var.container_port
#         }
#       ]

#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
#           awslogs-region        = var.region
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
# }
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = "${aws_ecr_repository.app_repo.repository_url}:latest"
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = var.app_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public1.id, aws_subnet.public2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.http]
}
