**🚀 AWS Multi-Region E-Commerce Microservices Deployment**

A full-stack, multi-region e-commerce platform built with Python Flask, ReactJS, and deployed to Amazon EKS using CloudFormation, Terraform, and a complete CI/CD pipeline with CodePipeline, CodeBuild, and ECR. It features high availability, automatic DNS failover with Route 53, and secure, scalable infrastructure using AWS best practices.
**
📚 Table of Contents
**
📘 Project Overview

🧱 Tech Stack

🌐 Multi-Region Deployment Strategy

📐 Architecture Diagram

📍 Region 1: CloudFormation Deployment (us-east-1)

📍 Region 2: Terraform Deployment (us-west-2)

🌎 DNS Failover via Route 53

📀 CI/CD Pipeline

📊 Monitoring & Logging

🔐 Security Best Practices

📈 Future Enhancements

👨‍💻 Author

💻 Useful Commands
**
1. 📘 Project Overview**

This capstone project showcases a highly available, resilient, and auto-healing deployment of a microservices-based e-commerce application using:

Multi-region Kubernetes clusters (EKS)

Centralized database via Amazon RDS (MySQL)

Automatic failover via Route 53 DNS

Fully automated CI/CD pipeline

**2. 🧱 Tech Stack**

Layer

Technology

Frontend

ReactJS

Backend

Python Flask

Database

Amazon RDS (MySQL, Multi-AZ)

Orchestration

Amazon EKS (Fargate/EC2 nodes)

Infra as Code

CloudFormation (us-east-1), Terraform (us-west-2)

CI/CD

CodePipeline, CodeBuild, ECR

Monitoring

CloudWatch, SNS

**3. 🌐 Multi-Region Deployment Strategy**

Region

Tool Used

Purpose

us-east-1

CloudFormation

Primary region

us-west-2

Terraform

Disaster recovery (DR)

✅ Failover handled automatically via Route 53 health checks.

**4. 📐 Architecture Diagram**

                       🌐 Internet
                            │
                        [ Route 53 ]
                     ↙                 ↘
      📍 us-east-1 (Primary)       📍 us-west-2 (Failover)
      ---------------------       ------------------------
            [ ALB ]                     [ ALB ]
               │                           │
           [ EKS ]                      [ EKS ]
               │                           │
 [ Flask Microservices ]    [ Flask Microservices ]
               │                           │
 [ RDS MySQL (Multi-AZ) ]   [ RDS MySQL (Multi-AZ) ]

**5. 📍 Region 1: CloudFormation Deployment (us-east-1)**

🧩 Components:

VPC with public/private subnets

EKS cluster with managed node groups

Multi-AZ Amazon RDS (MySQL)

ALB + NACLs + Security Groups

IAM roles for EKS, EC2, CodeBuild

CloudWatch integration

⚙️ Deployment Options:

Use CloudFormation template: vpc-eks-rds.yaml

Or deploy via CodePipeline (GitHub source)🔗 GitHub Repo – CloudFormation

**6. 📍 Region 2: Terraform Deployment (us-west-2)**

📂 Modules:

vpc.tf: Networking & subnets

eks.tf: EKS cluster, node group, IAM roles

rds.tf: MySQL instance (private subnet)

🛠️ Deploy:

cd region-2-terraform
terraform init
terraform apply

🔗 GitHub Repo – Terraform

**7. 🌎 DNS Failover via Route 53**

Record Type

Region

Role

Health Check

A (Alias)

us-east-1

PRIMARY

✅ Enabled

A (Alias)

us-west-2

SECONDARY

❌ Not Required

✅ Automatically redirects to secondary if primary region ALB is unhealthy.

**8. 📀 CI/CD Pipeline**

🧰 Tools:

Service

Purpose

CodePipeline

End-to-end automation

CodeBuild

Build, test, deploy to EKS

Amazon ECR

Docker image registry

S3

Optional – store build artifacts

🔁 Flow:

GitHub ──▶ CodeBuild ──▶ ECR ──▶ EKS (kubectl apply)

✅ Sample buildspec.yml:

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
**
9. 📊 Monitoring & Logging
**
Metric

Threshold

Action

RDS CPU Utilization

> 70%

SNS Email

EKS Pod CPU Utilization

> 80%

SNS Email

✅ Logs collected via CloudWatch Agent✅ Alerts delivered via SNS Notifications
**
10. 🔐 Security Best Practices
**
🔒 RDS in private subnets

🔐 Restrictive Security Groups & NACLs

🔑 IAM Roles follow least privilege principle

🧺 Secrets stored in Secrets Manager

🛡️ Ingress protected by ALB

**11. 📈 Future Enhancements**

✅ Blue-Green/Canary Deployments with Argo Rollouts

📊 Add Prometheus + Grafana for observability

🚡 Enable AWS WAF + Shield on ALB

🐳 Use Helm charts to deploy microservices

☁️ Support for multi-cloud Kubernetes (GKE, AKS)

**12. 👨‍💻 Author**

Kirthik Subbiah🔗 GitHub: @kirthiksubbiah🌐 Website: kirthiksubbiah.com

**13. 💻 Useful Commands**

# Connect kubectl to EKS cluster
aws eks update-kubeconfig --region <region> --name <cluster-name>

# View cluster resources
kubectl get nodes
kubectl get svc

# View logs for pods
kubectl logs -l app=myapp

💡 This project reflects best practices in AWS DevOps, multi-region cloud architecture, Kubernetes orchestration, and automated deployments for enterprise-grade applications.


