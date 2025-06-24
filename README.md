# 🚀 AWS Multi-Region E-Commerce Microservices Deployment (EKS, RDS, Route 53, CI/CD)

## 📌 Table of Contents
1. [Introduction](#1-introduction)  
2. [Application Overview](#2-application-overview)  
3. [Infrastructure Design Principles](#3-infrastructure-design-principles)  
4. [Overall Architecture](#4-overall-architecture)  
5. [CloudFormation Deployment - Region 1 (us-east-1)](#5-cloudformation-deployment---region-1-us-east-1)  
6. [Terraform Deployment - Region 2 (us-west-2)](#6-terraform-deployment---region-2-us-west-2)  
7. [Disaster Recovery using Route 53](#7-disaster-recovery-using-route-53)  
8. [CI/CD Pipeline Automation](#8-cicd-pipeline-automation)  
9. [Monitoring & Alerting](#9-monitoring--alerting)  
10. [Security Best Practices](#10-security-best-practices)  
11. [Future Enhancements](#11-future-enhancements)  
12. [Author](#12-author)  
13. [Useful Commands](#13-useful-commands)  

---

## 1. Introduction
This capstone project demonstrates a complete **multi-tier, multi-region deployment** of an e-commerce microservices application on AWS. It uses Amazon **EKS** for container orchestration, **Amazon RDS (MySQL)** for database, and **Route 53** for global DNS failover. Deployment is managed via **CloudFormation** in `us-east-1` and **Terraform** in `us-west-2`, along with CI/CD automation using **CodePipeline** and **CodeBuild**.

---

## 2. Application Overview

- **GitHub Repos**:
  - Region-1 (CloudFormation): [ecommerce-system](https://github.com/kirthiksubbiah/ecommerce-system.git)
  - Region-2 (Terraform): [ecommerce-system-terraform](https://github.com/kirthiksubbiah/ecommerce-system-terraform-.git)

- **Tech Stack**:
  - Frontend: ReactJS
  - Backend: python
  - Database: Amazon RDS (MySQL)
  - Infra Tools: AWS CloudFormation, Terraform
  - Deployment: Amazon EKS

---

## 3. Infrastructure Design Principles

| Goal             | Strategy                                                            |
|------------------|---------------------------------------------------------------------|
| High Availability| Multi-AZ subnets, Multi-region with Route 53 Failover               |
| Fault Tolerance  | Redundant node groups, health-based DNS routing                     |
| Scalability      | EKS Cluster Auto Scaling                                            |
| DR Readiness     | Active/Passive Multi-Region setup                                   |

---

## 4. Overall Architecture

                          🌐 Internet
                               |
                           [ Route 53 ]
                      /                   \
    📍 us-east-1 (CloudFormation)      📍 us-west-2 (Terraform)
    ---------------------------       ----------------------------
             [ ALB ]                            [ ALB ]
                |                                   |
             [ EKS ]                            [ EKS ]
                |                                   |
      [ Flask Microservices ]           [ Flask Microservices ]
                |                                   |
       [ RDS MySQL Database ]           [ RDS MySQL Database ]
             (Multi-AZ)                        (Multi-AZ)



---

## 5. CloudFormation Deployment - Region 1 (us-east-1)

### 🔧 Architecture Components
- **VPC & Networking**: Public/Private Subnets, NAT Gateway, IGW
- **EKS Cluster**: Control Plane + Managed Node Groups
- **RDS**: MySQL Multi-AZ
- **Monitoring**: CloudWatch + SNS
- **IAM**: Roles for EKS, EC2, CloudWatch, and CI/CD

### 🛠 Deployment Steps
Option 1:
- Create stack in CloudFormation with `vpc-eks-rds.yaml`

Option 2:
- Create a CodePipeline with GitHub as the source and deploy the CloudFormation template from the repository.

---

## 6. Terraform Deployment - Region 2 (us-west-2)

### 🗂 Terraform Modules
- `vpc.tf`: VPC, Subnets, IGW, NAT, Route Tables
- `eks.tf`: EKS Cluster & Node Group with IAM
- `rds.tf`: RDS MySQL Instance with Security Groups

### 🛠 Steps to Deploy

cd region-2-terraform
terraform init
terraform apply

**7. Disaster Recovery using Route 53**
   
🧠 Route 53 Failover Policy
Record Type	Region	Failover Role	Health Check
A (Alias)	us-east-1	PRIMARY	Enabled
A (Alias)	us-west-2	SECONDARY	Not Required

✅ If the primary region fails (based on ALB health check), Route 53 automatically routes traffic to the secondary region.

**8. CI/CD Pipeline Automation**
🧰 Tools Used
AWS Service	Purpose
CodePipeline	End-to-end deployment pipeline
CodeBuild	Build and deploy Spring Boot App
ECR (Optional)	Store Docker container images
S3 (Optional)	Artifact storage

🛠 Pipeline Structure

┌────────────┐       ┌────────────┐       ┌──────────────┐
│  GitHub    │ ───▶ │  CodeBuild │ ───▶  │EKS/K8s Deploy│
└────────────┘       └────────────┘       └──────────────┘
📄 Sample buildspec.yml

version: 0.2
phases:
  install:
    runtime-versions:
      java: corretto11
  build:
    commands:
      - mvn clean package
      - kubectl apply -f k8s/deployment.yaml
artifacts:
  files: ["**/*"]
  
**9. Monitoring & Alerting**
    
Metric	Threshold	Action
RDS CPUUtilization	> 70%	SNS Email
EKS Pod CPUUtilization	> 80%	SNS Email

✅ Alerts delivered via SNS Email Notifications
✅ Logs collected using CloudWatch Agent

**10. Security Best Practices**

🔒 Private RDS: Not publicly accessible

🔑 IAM Roles: Apply least privilege principle

🧪 Secrets Management: Use SSM Parameter Store or Secrets Manager

🔐 Ingress Controls: Restrict traffic using Security Groups and NACLs

**11. Future Enhancements**

✅ Add AWS WAF + Shield for additional ALB protection

✅ Integrate Prometheus + Grafana for real-time observability

✅ Enable Blue-Green or Canary Deployments with CodeDeploy or Argo Rollouts

✅ Use Helm charts for deploying K8s microservices

**12. Author**

👨‍💻 Kirthik Subbiah
🔗 GitHub: @kirthiksubbiah
🌐 Project Demo: http://kirthiksubbiah.com

**13. Useful Commands**

# Connect kubectl to EKS
aws eks update-kubeconfig --region <region> --name <cluster-name>

# Check cluster resources
kubectl get nodes
kubectl get svc

# View logs for your microservice
kubectl logs -l app=myapp
