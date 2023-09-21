output "node_group_arns" {
  description = "The Amazon Resource Names (ARNs) of the EKS Node Groups."
  value       = [for ng in aws_eks_node_group.node-ec2 : ng.arn]
}

output "node_group_ids" {
  description = "The EKS Node Group IDs."
  value       = [for ng in aws_eks_node_group.node-ec2 : ng.id]
}

output "node_group_statuses" {
  description = "The statuses of the EKS Node Groups."
  value       = [for ng in aws_eks_node_group.node-ec2 : ng.status]
}

output "node_group_roles" {
  description = "The IAM roles associated with the EKS Node Groups."
  value       = [for ng in aws_eks_node_group.node-ec2 : ng.node_role_arn]
}

output "openid_connect_provider_url" {
  description = "The URL of the IAM OIDC provider for the EKS cluster."
  value       = aws_iam_openid_connect_provider.default.url
}
