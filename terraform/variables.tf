variable "project_name" {
  type        = string
  description = "Project name used for tagging and resource naming"
  default     = "dockerproject"
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "container_port" {
  type        = number
  description = "Container port exposed by the app"
  default     = 3000
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks to run"
  default     = 2
}

variable "task_cpu" {
  type        = number
  description = "Fargate task CPU units"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "Fargate task memory (MiB)"
  default     = 512
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days"
  default     = 14
}

variable "ecr_repository_name" {
  type        = string
  description = "Name of the ECR repository"
  default     = "dockerproject-app"
}

variable "image_tag" {
  type        = string
  description = "Image tag used in the ECS task definition"
  default     = "latest"
}

variable "health_check_path" {
  type        = string
  description = "ALB health check path"
  default     = "/health"
}

variable "ecs_minimum_healthy_percent" {
  type        = number
  description = "Minimum healthy percent during deployments"
  default     = 50
}

variable "ecs_maximum_percent" {
  type        = number
  description = "Maximum percent during deployments"
  default     = 200
}

variable "alarm_actions" {
  type        = list(string)
  description = "CloudWatch alarm action ARNs (for example, SNS topics)"
  default     = []
}

variable "ok_actions" {
  type        = list(string)
  description = "CloudWatch OK action ARNs (for example, SNS topics)"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
}
