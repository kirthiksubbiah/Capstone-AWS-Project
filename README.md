🚀 AWS Multi-Region E-Commerce Microservices Deployment
📑 Table of Contents
📘 Project Overview

🧱 Tech Stack

🌐 Multi-Region Deployment Strategy

📐 Infrastructure Architecture

📍 Region 1 Deployment (us-east-1) – CloudFormation

📍 Region 2 Deployment (us-west-2) – Terraform

🌎 DNS Failover with Route 53

🔄 CI/CD Pipeline with CodePipeline + CodeBuild

📊 Monitoring & Logging

🔐 Security Best Practices

📈 Future Enhancements

👨‍💻 Author

💻 Useful Commands

1. Project Overview
This capstone project delivers a robust multi-tier, multi-region e-commerce microservices application hosted on Amazon EKS with a managed MySQL RDS backend, global Route 53 DNS failover, and CI/CD automation using AWS CodePipeline and CodeBuild.

2. Tech Stack
Layer	Technology
Frontend	ReactJS
Backend	Python Flask
Database	Amazon RDS MySQL (Multi-AZ)
Orchestration	Amazon EKS (Fargate/EC2 nodes)
Infrastructure	CloudFormation (us-east-1), Terraform (us-west-2)
CI/CD	CodePipeline, CodeBuild, ECR
Monitoring	Amazon CloudWatch, SNS

3. Multi-Region Deployment Strategy
Region	Tools Used	Purpose
us-east-1	CloudFormation	Primary Region
us-west-2	Terraform	Secondary (Failover) DR

4. Infrastructure Architecture
scss
Copy
Edit
                        🌐 Internet
                             │
                         [ Route 53 ]
                      ↙                 ↘
     📍 us-east-1 (CloudFormation)      📍 us-west-2 (Terraform)
     ---------------------------       ----------------------------
             [ ALB ]                            [ ALB ]
                │                                   │
             [ EKS ]                            [ EKS ]
                │                                   │
       [ Flask Microservices ]           [ Flask Microservices ]
                │                                   │
       [ RDS MySQL (Multi-AZ) ]          [ RDS MySQL (Multi-AZ) ]
5. Region 1 Deployment (us-east-1) – CloudFormation
Components:
Custom VPC with private/public subnets

EKS Cluster with managed node group

Amazon RDS with Multi-AZ MySQL

IAM Roles for EKS and EC2

Security Groups, NACLs, ALB

CloudWatch integration for logs and alerts

Deployment:
Deploy using CloudFormation Stack: vpc-eks-rds.yaml

Or automate via CodePipeline pointing to the GitHub repo:
🔗 ecommerce-system

6. Region 2 Deployment (us-west-2) – Terraform
Modules:
vpc.tf – Networking

eks.tf – EKS cluster, node groups, IAM

rds.tf – Amazon RDS with security groups

Deployment Steps:
bash
Copy
Edit
cd region-2-terraform
terraform init
terraform apply
🔗 Terraform Repo

7. DNS Failover with Route 53
Record Type	Region	Role	Health Check
A (Alias)	us-east-1	PRIMARY	Enabled
A (Alias)	us-west-2	SECONDARY	Not Required

✅ If the primary region becomes unhealthy, Route 53 automatically redirects traffic to the backup region.

8. CI/CD Pipeline with CodePipeline + CodeBuild
Tools:
Service	Role
CodePipeline	End-to-end deployment
CodeBuild	Docker build, SonarQube scan, kubectl apply
ECR	Docker image storage
S3	(Optional) Artifact store

Structure:
scss
Copy
Edit
GitHub ───▶ CodeBuild ───▶ ECR ───▶ EKS (kubectl)
buildspec.yml (Simplified):
yaml
Copy
Edit
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging into ECR...
      - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - docker build -t $REPO_URI:$IMAGE_TAG .
      - docker tag $REPO_URI:$IMAGE_TAG $REPO_URI:latest
  post_build:
    commands:
      - docker push $REPO_URI:$IMAGE_TAG
      - docker push $REPO_URI:latest
      - aws eks update-kubeconfig --region us-east-1 --name ecommerce-cluster
      - kubectl apply -f k8s/
artifacts:
  files:
    - k8s/*
✅ Fixes:

Made SonarQube analysis optional to avoid blocking builds

Corrected YAML formatting and Docker image validation

9. Monitoring & Logging
Metric	Threshold	Action
RDS CPUUtilization	> 70%	SNS Alert
EKS Pod CPUUtilization	> 80%	SNS Alert

✅ Integrated with CloudWatch Logs and SNS Email
✅ Container logs viewable with kubectl logs

10. Security Best Practices
🔒 RDS not publicly accessible

🔑 IAM roles with least privilege

🧪 Secrets managed via AWS Secrets Manager

🔐 Security Groups & NACLs restrict public access

11. Future Enhancements
🔁 Add Blue-Green or Canary deployment using CodeDeploy or Argo Rollouts

📈 Integrate Prometheus + Grafana for real-time metrics

🔐 Add AWS WAF and AWS Shield on ALB

🐳 Use Helm charts to deploy K8s microservices

12. Author
👨‍💻 Kirthik Subbiah
🔗 GitHub: @kirthiksubbiah
🌐 Project Demo: http://kirthiksubbiah.com

13. Useful Commands
bash
Copy
Edit
# Connect kubectl to EKS cluster
aws eks update-kubeconfig --region <region> --name <cluster-name>

# Check nodes and services
kubectl get nodes
kubectl get svc

# View logs for app pods
kubectl logs -l app=myapp
