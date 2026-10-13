output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.kubedeploy.name
}

output "cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = aws_eks_cluster.kubedeploy.endpoint
}

output "cluster_region" {
  description = "AWS region"
  value       = "eu-west-2"
}

output "node_group_name" {
  description = "Managed node group name"
  value       = aws_eks_node_group.kubedeploy_workers.node_group_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region eu-west-2 --name ${aws_eks_cluster.kubedeploy.name}"
}
