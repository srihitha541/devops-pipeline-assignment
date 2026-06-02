output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.this.name
}

output "ecs_task_family" {
  description = "ECS task definition family"
  value       = aws_ecs_task_definition.this.family
}

output "ecs_container_name" {
  description = "ECS container name"
  value       = local.container_name
}
