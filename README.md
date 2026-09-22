# KubeDeploy

## Kubernetes Application Deployment & Autoscaling Platform

KubeDeploy is a hands-on Kubernetes and DevOps portfolio project demonstrating how a containerised FastAPI application can be deployed, configured, monitored, scaled, and automatically recovered using Kubernetes.

The project demonstrates the operational lifecycle:

**Build → Containerise → Deploy → Configure → Monitor → Scale → Recover**

---

## Project Overview

KubeDeploy runs a Python FastAPI application inside Docker containers managed by Kubernetes.

The application is deployed using Kubernetes manifests and includes:

- Multiple application replicas
- ClusterIP service networking
- Liveness probes
- Readiness probes
- ConfigMaps
- Kubernetes Secrets
- CPU and memory resource controls
- Metrics Server
- Horizontal Pod Autoscaling
- Kubernetes self-healing
- Automatic scale-up and scale-down

The project was built and tested using Docker Desktop Kubernetes.

Then paste this in its place:

```markdown
# Solution Architecture

```text
Developer
   |
   v
GitHub Repository
   |
   v
Docker Image
   |
   v
Kubernetes Cluster
   |
   v
Kubernetes Deployment
   |
   +----------------------+
   |                      |
   v                      v
FastAPI Pod 1        FastAPI Pod 2
   ^                      ^
   |                      |
   +------ ConfigMap -----+
   +------- Secret -------+

Client / Port Forward
          |
          v
   ClusterIP Service
          |
          +----------> Pod 1
          |
          +----------> Pod 2

Metrics Server
      |
      v
Horizontal Pod Autoscaler
      |
      v
Kubernetes Deployment
      |
      v
Automatic Scaling
2 Pods  <----->  6 Pods

# Technology Stack

| Technology | Purpose |
|---|---|
| Python | Application development |
| FastAPI | REST API |
| Uvicorn | ASGI server |
| Docker | Containerisation |
| Kubernetes | Container orchestration |
| Docker Desktop | Local Kubernetes cluster |
| kubectl | Kubernetes administration |
| Metrics Server | CPU and memory metrics |
| HPA | Automatic pod scaling |
| ConfigMap | Application configuration |
| Secret | Sensitive configuration |
| Git | Version control |
| GitHub | Source repository |

---

# Application Endpoints

## Root

```text
/
```

Confirms the KubeDeploy API is running.

## Health Check

```text
/health
```

Example:

```json
{
  "status": "healthy"
}
```

## Readiness Check

```text
/ready
```

Example:

```json
{
  "status": "ready"
}
```

## API Documentation

```text
/docs
```

FastAPI provides interactive Swagger/OpenAPI documentation.

---

# Docker Container

The application is packaged into a Docker image.

Build:

```bash
docker build -t kubedeploy:latest .
```

Local test:

```bash
docker run -d \
  --name kubedeploy \
  -p 8001:8000 \
  kubedeploy:latest
```

Health validation:

```bash
curl http://localhost:8001/health
```

---

# Kubernetes Deployment

The application is managed through a Kubernetes Deployment.

Default configuration:

```text
Replicas: 2
Container Port: 8000
Image: kubedeploy:latest
```

Deployment:

```bash
kubectl apply -f kubernetes/deployment.yaml
```

Verify:

```bash
kubectl get deployments
kubectl get pods
```

---

# Kubernetes Service

A ClusterIP Service provides stable internal networking between Kubernetes and the application pods.

Apply:

```bash
kubectl apply -f kubernetes/service.yaml
```

Access locally:

```bash
kubectl port-forward service/kubedeploy-service 8080:80
```

Test:

```bash
curl http://localhost:8080/health
curl http://localhost:8080/ready
```

---

# Health Monitoring

KubeDeploy uses Kubernetes probes to continuously evaluate application health.

## Readiness Probe

```text
Endpoint: /ready
Port: 8000
Initial delay: 5 seconds
Period: 10 seconds
```

The readiness probe determines whether a pod should receive traffic.

## Liveness Probe

```text
Endpoint: /health
Port: 8000
Initial delay: 10 seconds
Period: 15 seconds
```

The liveness probe allows Kubernetes to detect unhealthy application containers.

---

# Kubernetes Self-Healing

Kubernetes self-healing was validated by manually deleting an application pod.

Example:

```bash
kubectl delete pod <pod-name>
```

The Deployment immediately detected that the desired replica count was no longer satisfied and automatically created a replacement pod.

The application returned to:

```text
2/2 Running
```

without manually recreating the deleted pod.

This demonstrates Kubernetes desired-state reconciliation.

---

# Manual Scaling

The Deployment was manually scaled from two replicas to four replicas:

```bash
kubectl scale deployment kubedeploy --replicas=4
```

Validation:

```text
READY:       4/4
UP-TO-DATE:  4
AVAILABLE:   4
```

The Deployment was subsequently returned to two replicas.

---

# ConfigMap

Non-sensitive runtime configuration is managed using a Kubernetes ConfigMap.

Configured values include:

```text
APP_ENV=kubernetes
APP_NAME=KubeDeploy
```

Apply:

```bash
kubectl apply -f kubernetes/configmap.yaml
```

The configuration is injected into application pods using `envFrom`.

The values were validated from inside a running pod.

---

# Kubernetes Secrets

Sensitive configuration is handled separately using Kubernetes Secrets.

The real local secret file is:

```text
kubernetes/secret.yaml
```

This file is intentionally excluded from Git using `.gitignore`.

A safe example is included:

```text
kubernetes/secret.example.yaml
```

Example:

```yaml
stringData:
  API_KEY: "replace-with-your-secret"
```

This demonstrates how sensitive runtime configuration can be kept separate from normal application configuration.

---

# Resource Management

Each application pod defines CPU and memory requests and limits.

```text
Requests:
CPU:    100m
Memory: 64Mi

Limits:
CPU:    250m
Memory: 128Mi
```

Requests help Kubernetes schedule workloads appropriately.

Limits prevent individual containers from consuming excessive cluster resources.

---

# Kubernetes Metrics

Metrics Server was installed to provide live resource usage information.

Example:

```bash
kubectl top pods
```

This provides:

- Pod CPU usage
- Pod memory usage

Metrics are also used by the Horizontal Pod Autoscaler.

---

# Horizontal Pod Autoscaling

KubeDeploy includes a Horizontal Pod Autoscaler.

Configuration:

```text
Minimum replicas: 2
Maximum replicas: 6
CPU target:       50%
```

The HPA continuously evaluates CPU utilisation and automatically adjusts the Deployment replica count.

Apply:

```bash
kubectl apply -f kubernetes/hpa.yaml
```

Monitor:

```bash
kubectl get hpa
```

---

# Autoscaling Test

Horizontal autoscaling was tested using a dedicated load-generator pod.

Under normal conditions:

```text
CPU: approximately 3%
Replicas: 2
```

During the load test, CPU usage rose above the configured 50% target.

Observed utilisation exceeded:

```text
100% of requested CPU
```

Kubernetes automatically scaled the application from:

```text
2 pods
```

to:

```text
6 pods
```

After the load-generator pod was removed, CPU utilisation decreased.

Following the HPA scale-down stabilisation period, Kubernetes automatically returned the Deployment to:

```text
2 pods
```

This validated the complete autoscaling lifecycle:

```text
Normal Load
    │
    ▼
2 Pods
    │
    ▼
CPU Increases
    │
    ▼
HPA Detects High Utilisation
    │
    ▼
Scale Up
    │
    ▼
6 Pods
    │
    ▼
Load Removed
    │
    ▼
CPU Decreases
    │
    ▼
Automatic Scale Down
    │
    ▼
2 Pods
```

---

# CI/CD Pipeline

KubeDeploy includes automated CI/CD workflows using GitHub Actions.

The pipeline is triggered whenever code is pushed to the `main` branch.

The CI workflow performs:

```text
GitHub Push
    |
    v
Checkout Repository
    |
    v
Set Up Python
    |
    v
Install Dependencies
    |
    v
Validate FastAPI Application
    |
    v
Build Docker Image
    |
    v
Validate Kubernetes Manifests
    |
    v
CI Success
```

The Kubernetes manifests are validated using `kubeconform`, allowing schema validation to run without requiring a live Kubernetes cluster.

---

# Container Image Publishing

A separate GitHub Actions workflow automatically builds and publishes the KubeDeploy Docker image to GitHub Container Registry.

The published image is:

```text
ghcr.io/kvngmuhy94/kubedeploy-kubernetes-platform:latest
```

The workflow also publishes a commit-specific image tag using the Git commit SHA.

This provides both:

- A convenient `latest` image
- Immutable image versions tied to individual Git commits

---

# Multi-Architecture Docker Images

KubeDeploy publishes multi-platform Docker images supporting:

```text
linux/amd64
linux/arm64
```

This allows the same container image to run on:

- Intel/AMD Linux systems
- Apple Silicon systems
- Compatible Kubernetes environments

GitHub Actions uses Docker Buildx and QEMU to build the multi-platform image.

---

# Registry-Backed Kubernetes Deployment

The Kubernetes Deployment uses the published GitHub Container Registry image:

```yaml
image: ghcr.io/kvngmuhy94/kubedeploy-kubernetes-platform:latest
```

This means Kubernetes no longer depends on a locally built Docker image.

The deployment workflow is now:

```text
Application Code
      |
      v
GitHub Repository
      |
      v
GitHub Actions CI
      |
      +----> Python Validation
      |
      +----> Docker Build
      |
      +----> Kubernetes Manifest Validation
      |
      v
GitHub Container Registry
      |
      v
Multi-Architecture Docker Image
      |
      v
Kubernetes Deployment
      |
      v
Application Pods
      |
      v
Health + Readiness Validation
```

---

# CI/CD Validation

The automated pipeline was successfully tested for:

- GitHub push triggers
- Python dependency installation
- FastAPI syntax validation
- Docker image builds
- Kubernetes manifest validation using kubeconform
- GHCR authentication
- Docker image publishing
- Multi-platform image builds
- ARM64 image pulling
- Kubernetes deployment from GHCR
- Successful rollout
- Health endpoint validation
- Readiness endpoint validation

Final application checks returned:

```json
{"status":"healthy"}
```

and:

```json
{"status":"ready"}
```

---

# Kubernetes Resources

The project uses the following manifests:

```text
kubernetes/
├── configmap.yaml
├── deployment.yaml
├── hpa.yaml
├── secret.example.yaml
└── service.yaml
```

The local secret file is intentionally excluded:

```text
kubernetes/secret.yaml
```

---

# Repository Structure

```text
kubedeploy-kubernetes-platform/
│
├── app/
│   ├── main.py
│   └── requirements.txt
│
├── kubernetes/
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── secret.example.yaml
│   └── service.yaml
│
├── Dockerfile
├── .gitignore
└── README.md
```

---

# Deployment Workflow

The application deployment workflow is:

```text
Application Code
      │
      ▼
Docker Image
      │
      ▼
Kubernetes Deployment
      │
      ▼
Application Pods
      │
      ▼
ClusterIP Service
      │
      ▼
Health / Readiness Checks
      │
      ▼
Metrics Server
      │
      ▼
Horizontal Pod Autoscaler
```

---

# Operational Workflow

Useful operational commands include:

```bash
kubectl get pods
```

```bash
kubectl get services
```

```bash
kubectl get deployments
```

```bash
kubectl get hpa
```

```bash
kubectl top pods
```

```bash
kubectl describe deployment kubedeploy
```

```bash
kubectl logs <pod-name>
```

```bash
kubectl rollout status deployment/kubedeploy
```

---

# Skills Demonstrated

KubeDeploy demonstrates practical experience with:

- Kubernetes architecture
- Docker containers
- Kubernetes Deployments
- Pods
- Services
- Replica management
- Liveness probes
- Readiness probes
- ConfigMaps
- Secrets
- Resource requests
- Resource limits
- Metrics Server
- Horizontal Pod Autoscaling
- Self-healing
- Service discovery
- Rolling updates
- Load testing
- kubectl
- Git
- GitHub
-  CI/CD and Container Registry

- GitHub Actions
- Automated CI pipelines
- Automated Docker builds
- GitHub Container Registry
- Docker Buildx
- QEMU
- Multi-architecture images
- kubeconform
- Registry-backed Kubernetes deployment

---

# Project Validation

The project was tested successfully for:

- Docker image build
- Local container execution
- Health endpoint
- Readiness endpoint
- Kubernetes Deployment
- Two-replica operation
- ClusterIP Service
- Port forwarding
- Pod self-healing
- Manual scaling from 2 to 4 pods
- ConfigMap injection
- Secret injection
- CPU requests and limits
- Memory requests and limits
- Metrics Server
- CPU monitoring
- HPA creation
- Automatic scale-up from 2 to 6 pods
- Automatic scale-down from 6 to 2 pods

---

# Project Status

**KubeDeploy is operationally validated.**

The application has successfully demonstrated deployment, configuration management, health checking, self-healing, resource management, metrics collection, and automatic horizontal scaling in Kubernetes.
# Project Status

**KubeDeploy is complete and operationally validated.**

The project now demonstrates an end-to-end DevOps workflow covering application development, containerisation, Kubernetes orchestration, health monitoring, self-healing, autoscaling, automated CI validation, multi-architecture Docker image publishing, GitHub Container Registry integration, and Kubernetes deployment from a remote container registry.

---

# Interview Summary

KubeDeploy can be described as:

> KubeDeploy is a Kubernetes portfolio project where I containerised a FastAPI application with Docker and deployed it to a local Kubernetes cluster. I configured Deployments, Services, readiness and liveness probes, ConfigMaps, Secrets, CPU and memory resource controls, Metrics Server and Horizontal Pod Autoscaling. I tested self-healing by deleting a pod and confirming Kubernetes automatically replaced it. I also generated CPU load and demonstrated the HPA automatically scaling the application from two pods to six and then back down to two once demand decreased.

---

# Learning Outcomes

The project provided hands-on experience with how Kubernetes maintains desired application state.

It demonstrated the difference between simply running containers and orchestrating containers in a resilient environment.

Key lessons included:

- Kubernetes desired-state management
- Automatic workload recovery
- Horizontal application scaling
- Service-based networking
- Health-based traffic management
- Runtime configuration
- Secret management
- Resource governance
- Metrics-driven scaling
- Declarative infrastructure configuration
- Operational troubleshooting

---

# Future Enhancements

Potential future improvements include:

- Kubernetes Ingress
- TLS/HTTPS
- Helm charts
- CI/CD with GitHub Actions
- Container registry integration
- Prometheus monitoring
- Grafana dashboards
- Kubernetes namespaces
- Network Policies
- Persistent storage
- AWS EKS deployment
- Rolling deployment strategies

---

# Author

**Amos Agboola**

Cloud / DevOps Portfolio Project

KubeDeploy was built as a practical demonstration of Kubernetes deployment, orchestration, monitoring, scaling, configuration management, and operational recovery.
