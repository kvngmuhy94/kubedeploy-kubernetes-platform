# KubeDeploy Portfolio Evidence

## AWS EKS
- EKS cluster running in eu-west-2
- Managed worker node in Ready state
- KubeDeploy pods running on EKS
- AWS LoadBalancer service
- Public /health endpoint returning healthy

## CI/CD
- GitHub Actions CI workflow
- Multi-platform Docker image build
- GHCR publishing
- Automated Kubernetes deployment
- Rollout verification
- Automatic rollback
- Post-deployment health check

## Monitoring
- Prometheus metrics
- Grafana dashboard
- Alertmanager
- Email alert notification

## Resilience Testing
- Failed image deployment
- ImagePullBackOff observed
- Rollback to previous working revision
- Pods restored to Running state
