# 🛒 E-Commerce Microservice Capstone Project

This project is a cloud-native, multi-region **e-commerce application** built using microservices architecture. The backend (Product & Order services) is developed in **Flask**, the frontend in **ReactJS**, and the entire stack is deployed on **Amazon EKS**. The infrastructure is provisioned across **two AWS regions** using **CloudFormation** and **Terraform**, while **CI/CD pipelines** and **Route 53 DNS failover** ensure automated deployments and high availability. Monitoring and alerts are powered by **CloudWatch**, **SNS**, **Prometheus**, and **Grafana**.

---

## 📌 Project Goals

- 🚀 Deploy a containerized e-commerce application (Product, Order, Frontend) on **Amazon EKS**
- ⚙️ Automate infrastructure setup using **Terraform** (Region B) and **CloudFormation** (Region A)
- 📦 Implement **CI/CD** using AWS CodePipeline and CodeBuild
- 🌍 Setup multi-region failover using **Amazon Route 53**
- 📊 Monitor infrastructure and application using **CloudWatch**, **Prometheus**, **Grafana**

---

## ⚙️ Architecture Components

| Component         | Tool / Service                    | Description                                           |
|------------------|------------------------------------|-------------------------------------------------------|
| Application Layer| EKS + Docker                       | Product, Order, and Frontend microservices           |
| CI/CD            | AWS CodePipeline, CodeBuild        | Automates image builds, scans, and deployments       |
| Infra (Region A) | AWS CloudFormation                 | VPC, EKS, RDS, ALB setup in us-east-1                |
| Infra (Region B) | Terraform                          | Infra replica setup in us-west-2                     |
| GitOps           | Argo CD                            | Auto-sync apps from GitHub to EKS                    |
| Monitoring       | CloudWatch, Prometheus, Grafana    | Logs, metrics, dashboards, and alerts                |
| Security         | Trivy, SonarQube                   | Image scanning and static code analysis              |
| DNS Failover     | Amazon Route 53                    | Health checks and multi-region failover              |

region A - https://github.com/kirthiksubbiah/ecommerce-system.git

region B - https://github.com/kirthiksubbiah/ecommerce-system-terraform-.git

---

## 🔧 Tools Used

- **Amazon EKS** – Kubernetes orchestration  
- **AWS ECR** – Docker image registry  
- **Docker** – Containerization of services  
- **Kubernetes** – Pod and service management  
- **AWS CodePipeline / CodeBuild** – CI/CD automation  
- **ArgoCD** – GitOps deployment for Kubernetes  
- **Trivy** – Container image vulnerability scanner  
- **SonarQube** – Code quality analysis  
- **Terraform** – Infra-as-code (Region B)  
- **CloudFormation** – Infra-as-code (Region A)  
- **Route 53** – DNS-based failover  
- **CloudWatch, Prometheus, Grafana** – Monitoring  

---
