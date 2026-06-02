# Architecture

This solution uses a standard CI/CD pipeline to build, test, and deploy a containerized Node.js service to Amazon ECS Fargate behind an Application Load Balancer.

## Flow
1. Developer pushes code to GitHub.
2. GitHub Actions runs linting, unit tests, and Docker build.
3. The pipeline pushes the container image to Amazon ECR.
4. The pipeline registers a new ECS task definition and updates the ECS service.
5. ECS performs a rolling deployment across two Availability Zones.
6. The Application Load Balancer routes traffic to healthy tasks on port 3000.
7. CloudWatch collects logs and alarms on CPU and memory utilization.

## Resiliency
- ECS service runs across two private subnets for high availability.
- Rolling deployments with minimum/maximum healthy percentages reduce downtime.
- Deployment circuit breaker automatically rolls back unhealthy releases.

## Observability
- CloudWatch Log Group stores container logs.
- CloudWatch alarms trigger when CPU or Memory exceeds 80%.
