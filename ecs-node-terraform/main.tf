provider "aws" {
  region = "ap-south-1"
}

# resource "aws_ecr_repository" "node_app" {
#  name = "node-ecs-app"
#}

resource "aws_ecs_cluster" "app_cluster" {
  name = "node-app-cluster"
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "node_task" {
  family                   = "node-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "node-app",
      image     = "476813399880.dkr.ecr.ap-south-1.amazonaws.com/node-ecs-app:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "node_service" {
  name            = "node-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.node_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-032b787321e05c875"]
    security_groups  = ["sg-0ebd8eda112c8dd0d"]
    assign_public_ip = true
  }
}

git log 

PS C:\Users\vaibh\ecs-node-app\ecs-node-terraform> git log --oneline
976ee7b (HEAD -> main) Remove .terraform and add .gitignore
af7d8c2 Remove .terraform directory from repo
e448155 Merge branch 'main' of https://github.com/Vaibhav-code/Rearc-project
2367654 Initial commit with ECS Fargate deployment setup
62b307c Initial commit
