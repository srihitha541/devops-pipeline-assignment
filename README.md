# DockerProject - ECS Fargate Deployment

## Project Overview
This repository contains a production-ready Node.js service packaged as a Docker image and deployed on AWS ECS Fargate behind an Application Load Balancer. Infrastructure is provisioned with Terraform and deployments are automated with GitHub Actions.

## Architecture
- Source control: GitHub
- CI/CD: GitHub Actions
- Container registry: Amazon ECR
- Compute: Amazon ECS Fargate (2 tasks, multi-AZ)
- Load balancing: Application Load Balancer
- Logging: CloudWatch Log Group
- Monitoring: CloudWatch CPU/Memory alarms

See the detailed architecture in [docs/architecture.md](docs/architecture.md) and the diagram in [docs/architecture-diagram.drawio](docs/architecture-diagram.drawio).

## Prerequisites
- AWS account with permissions to create VPC, ECS, ECR, IAM, ALB, and CloudWatch
- AWS CLI configured locally
- Terraform >= 1.5
- Node.js 20+
- Docker

## AWS Setup
1. Create an IAM user or role with permissions for ECS, ECR, EC2 networking, IAM, ALB, and CloudWatch.
2. Configure AWS CLI:
   - `aws configure`

## Local Development
From the app directory:
1. `npm install`
2. `npm start`
3. Test endpoints:
   - `Invoke-WebRequest -UseBasicParsing http://localhost:3000/ | Select-Object -ExpandProperty Content`
   - `Invoke-WebRequest -UseBasicParsing http://localhost:3000/health | Select-Object -ExpandProperty Content`

## Docker Build
From the repository root:
1. `docker build -f app/Dockerfile -t dockerproject-app:local app`
2. `docker run -p 3000:3000 dockerproject-app:local`

## Terraform Deployment
From the terraform directory:
1. `terraform init`
2. `terraform validate`
3. `terraform plan -out=tfplan`
4. `terraform apply tfplan`

Terraform outputs will include the ALB DNS name, ECS cluster/service names, and the ECR repository URL.

## ECR
After Terraform creates the ECR repo:
1. Authenticate Docker:
   - `aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com`
2. Build and push:
   - `docker build -f app/Dockerfile -t <ecr-url>:latest app`
   - `docker push <ecr-url>:latest`

## ECS
The ECS service runs in private subnets and is fronted by an ALB. It uses rolling deployments and a deployment circuit breaker for automatic rollback.

## GitHub Actions
Pipeline stages:
1. Checkout
2. Setup Node.js
3. Install dependencies
4. Lint
5. Unit tests
6. Build Docker image
7. Configure AWS credentials
8. Login to ECR
9. Push Docker image
10. Register new task definition
11. Update ECS service
12. Wait for stable deployment

### Required GitHub Secrets
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `ECR_REPOSITORY`
- `ECS_CLUSTER`
- `ECS_SERVICE`
- `ECS_TASK_FAMILY`
- `ECS_CONTAINER_NAME`

## Deployment Procedure
1. Merge to `main`.
2. GitHub Actions builds and pushes the image to ECR.
3. GitHub Actions registers a new task definition and updates the ECS service.
4. ECS performs a rolling deployment.

## Rolling Deployment
The ECS service is configured with:
- `deployment_minimum_healthy_percent = 50`
- `deployment_maximum_percent = 200`
This ensures at least half of the tasks stay healthy during updates.

## Rollback Procedure
Automatic rollback is enabled with the deployment circuit breaker:
- `deployment_circuit_breaker { enable = true, rollback = true }`
If tasks fail health checks, ECS rolls back to the last stable task definition.

Manual rollback:
1. Identify the last stable task definition revision.
2. Run:
   - `aws ecs update-service --cluster <cluster> --service <service> --task-definition <task-def-arn>`

## Logs
View container logs in CloudWatch:
- Log group: `/ecs/<project-name>`
- Example command:
  - `aws logs tail /ecs/<project-name> --since 1h --follow`

## Monitoring
CloudWatch alarms:
- CPU utilization > 80%
- Memory utilization > 80%

Attach SNS topics to alarm actions using `alarm_actions` and `ok_actions` in Terraform.

## Troubleshooting
- Ensure the ALB target group health check path is `/health`.
- Confirm ECS tasks have outbound internet access (NAT gateway in private subnets).
- Check IAM roles for ECR pull and CloudWatch logging permissions.
- Inspect CloudWatch logs for application errors.

## Destroy Infrastructure
From the terraform directory:
1. `terraform destroy`

## Future Improvements
- Use OIDC for GitHub Actions instead of static AWS keys.
- Replace NAT gateway with VPC endpoints where cost optimized.
- Add HTTPS with ACM and ALB listener on 443.
- Add autoscaling policies for ECS service.
