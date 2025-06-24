**🚀 AWS Multi-Region E-Commerce Microservices Deployment
**
A full-stack, production-grade e-commerce platform deployed across multiple AWS regions. Built with Python Flask (backend), ReactJS (frontend), and powered by Amazon EKS, this solution is fully automated using CloudFormation, Terraform, and a complete CI/CD pipeline (CodePipeline, CodeBuild, ECR). It ensures high availability, auto-healing, and DNS failover with Route 53, all while following AWS best practices for security, scalability, and observability.

**📘 Project Overview
**
This capstone project demonstrates:

Highly available, multi-region architecture

Microservices deployed on Amazon EKS

Centralized RDS MySQL database (Multi-AZ)

Automated deployments via CI/CD pipeline

DNS health-based failover using Route 53

Infrastructure as Code (IaC) using CloudFormation & Terraform

**🧱 Tech Stack
**
Frontend: ReactJS
Backend: Python Flask
Database: Amazon RDS (MySQL, Multi-AZ)
Orchestration: Amazon EKS (Fargate/EC2)
Infra as Code: CloudFormation (us-east-1), Terraform (us-west-2)
CI/CD: CodePipeline, CodeBuild, Amazon ECR
Monitoring: CloudWatch, SNS

**🌐 Multi-Region Deployment Strategy
**
us-east-1 → Primary Region (CloudFormation)

us-west-2 → Disaster Recovery (Terraform)

Route 53 handles DNS-based health checks and automatic failover

**📐 Architecture Diagram
**

                    🌐 Internet
                         │
                     [ Route 53 ]
                  ↙                 ↘
     📍 us-east-1 (Primary)     📍 us-west-2 (Failover)
     ----------------------     ------------------------
            [ ALB ]                   [ ALB ]
              │                         │
           [ EKS ]                   [ EKS ]
              │                         │
 [ Flask Microservices ]     [ Flask Microservices ]
              │                         │
 [ RDS MySQL (Multi-AZ) ]    [ RDS MySQL (Multi-AZ) ]


**📍 Region 1: CloudFormation Deployment (us-east-1)
Components:**
Custom VPC (public/private subnets)

Amazon EKS with managed node groups

Amazon RDS MySQL (Multi-AZ)

Application Load Balancer (ALB)

IAM roles for EKS, EC2, and CodeBuild

NACLs, Security Groups

CloudWatch logging and metrics

Deploy Options:
Use vpc-eks-rds.yaml CloudFormation template

Or deploy via CodePipeline from GitHub

**📍 Region 2: Terraform Deployment (us-west-2)
Modules:**

vpc.tf: Networking setup

eks.tf: EKS cluster and node group

rds.tf: Private RDS MySQL setup
**
Deploy Steps:**

cd region-2-terraform
terraform init
terraform apply

🌎 DNS Failover via Route 53
A (Alias) record for us-east-1 → PRIMARY ✅

A (Alias) record for us-west-2 → SECONDARY ✅

Health checks monitor the ALB in us-east-1 and redirect traffic to us-west-2 on failure

**📀 CI/CD Pipeline**
Tools:
CodePipeline: Orchestrates the entire flow

CodeBuild: Builds Docker images and applies Kubernetes manifests

ECR: Stores built images

S3: (Optional) Stores artifacts

Flow:
GitHub → CodeBuild → ECR → EKS (kubectl apply)

Sample buildspec.yml:

version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging into Amazon ECR...
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
**📊 Monitoring & Logging
Metrics Tracked: EKS CPU/Memory usage
**
Threshold Example: CPU > 80% → SNS Email alert

Logging: CloudWatch Agent

Alerting: SNS Notifications

🔐 Security Best Practices
✅ RDS placed in private subnets

✅ ALB exposed, services in private

✅ IAM roles follow least privilege

✅ All secrets stored securely in AWS Secrets Manager

✅ NACLs and SGs strictly configured

✅ ALB handles Ingress securely

📈 Future Enhancements
✅ Implement blue-green or canary deployments using Argo Rollouts

📊 Integrate Prometheus & Grafana for real-time monitoring

🛡️ Enable AWS WAF and Shield for threat protection

🐳 Use Helm charts for easier microservice deployment

🌍 Explore multi-cloud Kubernetes (GKE, AKS) for portability

👨‍💻 Author
Kirthik Subbiah
🔗 GitHub: @kirthiksubbiah
🌐 Website: kirthiksubbiah.com

💻 Useful Commands
bash
Copy
Edit
# Connect kubectl to EKS cluster
aws eks update-kubeconfig --region <region> --name <cluster-name>

# View cluster resources
kubectl get nodes
kubectl get svc

# View logs
kubectl logs -l app=<app-name>
