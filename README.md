# KubeDeploy

> **Production-style Kubernetes & AWS EKS DevOps portfolio project** demonstrating containerisation, Infrastructure as Code, CI/CD, observability, autoscaling, health checks, automated rollout verification, rollback, and cloud resource lifecycle management.

[![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com/eks/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Containerised-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus&logoColor=white)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Grafana-Observability-F46800?logo=grafana&logoColor=white)](https://grafana.com/)

---

## Project Summary

KubeDeploy is an end-to-end DevOps project built around a Python FastAPI application.

The project started as a local containerised application, progressed into a resilient Kubernetes workload, and was then deployed to **Amazon EKS in eu-west-2** using **Terraform**.

It demonstrates the complete delivery and operations lifecycle:

**Build → Containerise → Validate → Publish → Provision → Deploy → Monitor → Scale → Recover → Destroy**

The AWS environment was successfully created, validated, exposed through an AWS Load Balancer, tested through the public health endpoint, and then safely destroyed to avoid unnecessary cloud costs.

---

## What This Project Demonstrates

- Docker containerisation
- Kubernetes Deployments and Services
- Multiple application replicas
- Liveness and readiness probes
- ConfigMaps and Secrets
- CPU and memory resource controls
- Horizontal Pod Autoscaling
- Kubernetes self-healing
- GitHub Actions CI/CD
- GitHub Container Registry
- Multi-architecture Docker images
- Automated rollout verification
- Post-deployment health checks
- Automatic rollback
- Prometheus monitoring
- Grafana dashboards
- Alertmanager email notifications
- AWS EKS
- AWS Load Balancer
- Terraform Infrastructure as Code
- AWS IAM and networking
- Infrastructure teardown and dependency troubleshooting

---

## Architecture

\`\`\`text
Developer
   |
   v
GitHub Repository
   |
   v
GitHub Actions
   |
   +-----------------------+
   |                       |
   v                       v
CI Validation         Docker Build
                           |
                           v
                  GitHub Container Registry
                           |
                           v
                        AWS EKS
                           |
                  +--------+--------+
                  |                 |
                  v                 v
           KubeDeploy Pod 1  KubeDeploy Pod 2
                  |                 |
                  +--------+--------+
                           |
                           v
                 Kubernetes Service
                           |
                           v
                  AWS Load Balancer
                           |
                           v
                    Public Endpoint


Monitoring
----------
KubeDeploy
    |
    v
Prometheus
  |      |
  |      +----> Grafana
  |
  +-----------> Alertmanager
                    |
                    v
               Email Alerts


Infrastructure
--------------
Terraform
   |
   +--> VPC
   +--> Public Subnets
   +--> Internet Gateway
   +--> Route Table
   +--> IAM Roles
   +--> EKS Cluster
   +--> Managed Node Group
\`\`\`

---

## Technology Stack

| Area | Technologies |
|---|---|
| Application | Python, FastAPI, Uvicorn |
| Containers | Docker, Docker Buildx |
| Orchestration | Kubernetes, kubectl |
| Cloud | AWS EKS, EC2, ELB, IAM, VPC |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Registry | GitHub Container Registry |
| Monitoring | Prometheus |
| Visualisation | Grafana |
| Alerting | Alertmanager |
| Scaling | Kubernetes HPA, Metrics Server |
| Validation | kubeconform, health checks |
| Version Control | Git, GitHub |

---

## Application Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Confirms the API is running |
| `/health` | Health validation |
| `/ready` | Readiness validation |
| `/metrics` | Prometheus metrics |
| `/docs` | FastAPI Swagger documentation |

Example:

\`\`\`json
{"status":"healthy"}
\`\`\`

---

## CI/CD Pipeline

\`\`\`text
Developer Push
      |
      v
GitHub Repository
      |
      v
Application Validation
      |
      v
Kubernetes Manifest Validation
      |
      v
Docker Build
      |
      v
GitHub Container Registry
      |
      v
Kubernetes Deployment
      |
      v
Rollout Verification
      |
      +--------------------+
      |                    |
      v                    v
Health Check        Automatic Rollback
\`\`\`

The pipeline has been tested for Docker builds, manifest validation, GHCR publishing, Kubernetes rollout verification and application health checks.

Published image:

\`\`\`text
ghcr.io/kvngmuhy94/kubedeploy-kubernetes-platform:latest
\`\`\`

---

## Kubernetes Resilience & Scaling

KubeDeploy runs multiple replicas and uses Kubernetes desired-state reconciliation.

Self-healing was tested by manually deleting an application pod and confirming that Kubernetes automatically created a replacement.

Horizontal Pod Autoscaling was also tested under CPU load:

\`\`\`text
2 Pods
   |
   v
CPU Load Increased
   |
   v
HPA Triggered
   |
   v
6 Pods
   |
   v
Load Removed
   |
   v
2 Pods
\`\`\`

---

## AWS EKS Deployment

KubeDeploy was successfully deployed to **Amazon EKS in eu-west-2**.

The tested environment included:

- Amazon EKS control plane
- Managed EC2 worker node group
- Multiple KubeDeploy replicas
- Kubernetes ConfigMap and Secret integration
- Readiness and health checks
- Kubernetes LoadBalancer Service
- AWS Elastic Load Balancer
- Public `/health` endpoint
- GitHub Actions deployment integration

After validation, the temporary environment was intentionally destroyed to avoid unnecessary AWS costs.

---

## Infrastructure as Code

Terraform provisions:

- VPC
- Public subnets
- Internet gateway
- Route table
- IAM roles and policies
- EKS cluster
- Managed worker node group

Provision:

\`\`\`bash
cd terraform
terraform init
terraform plan
terraform apply
\`\`\`

Configure kubectl:

\`\`\`bash
aws eks update-kubeconfig \
  --region eu-west-2 \
  --name kubedeploy-eks
\`\`\`

Destroy:

\`\`\`bash
terraform destroy
\`\`\`

---

## Monitoring & Observability

KubeDeploy includes:

- Prometheus
- Grafana
- kube-prometheus-stack
- ServiceMonitor
- Kubernetes metrics
- Application metrics
- Alertmanager

Prometheus collects application metrics from:

\`\`\`text
/metrics
\`\`\`

Grafana dashboards include request rate, HTTP status codes, latency, pod availability, CPU usage, memory usage and service health.

Alertmanager was successfully configured and tested with email notifications.

---

## Repository Structure

\`\`\`text
kubedeploy-kubernetes-platform/
|
├── .github/
|   └── workflows/
├── app/
├── docs/
├── kubernetes/
├── monitoring/
├── terraform/
├── Dockerfile
├── Makefile
├── eks-cluster.yaml
└── README.md
\`\`\`

---

## Real Troubleshooting Experience

This project included practical troubleshooting of:

- Kubernetes contexts
- Docker Desktop vs AWS EKS connectivity
- AWS IAM permissions
- AWS CLI authentication
- Kubernetes LoadBalancer dependencies
- Terraform destroy dependency errors
- ELB security groups
- VPC deletion
- Prometheus targets
- Alertmanager notifications
- Kubernetes rollout verification
- Application health checks

---

## Key Outcomes

KubeDeploy successfully demonstrated:

- Containerised FastAPI application
- Automated Docker image publishing
- Kubernetes orchestration
- Multiple replicas
- Self-healing
- Horizontal autoscaling
- Health and readiness checks
- CI/CD automation
- Prometheus monitoring
- Grafana dashboards
- Alertmanager notifications
- AWS EKS deployment
- Public AWS Load Balancer access
- Terraform-managed cloud infrastructure
- Successful infrastructure teardown

---

## Interview Summary

> I built KubeDeploy as an end-to-end DevOps portfolio project around a FastAPI application. I containerised the application with Docker, deployed it to Kubernetes, implemented health checks, self-healing and horizontal autoscaling, and created CI/CD pipelines using GitHub Actions and GitHub Container Registry. I added Prometheus, Grafana and Alertmanager for observability and deployed the workload to AWS EKS. I provisioned the AWS networking, IAM and EKS infrastructure using Terraform, validated the application through an AWS Load Balancer, and safely destroyed the cloud environment after testing.

---

## Project Status

**Complete and operationally validated.**

The source code and Infrastructure as Code remain available so the environment can be recreated when required. The temporary AWS environment used for testing has been destroyed to control cloud costs.

---

## Author

**Amos Agboola**

Cloud / DevOps Portfolio Project
