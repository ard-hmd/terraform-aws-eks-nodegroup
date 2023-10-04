# Create an IAM role for EKS node group with a specific assume role policy.
resource "aws_iam_role" "NodeGroupRole" {
  name = "EKSNodeGroupRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "${var.resource_name_prefix}iam-role"
  }
}

# Attach the Amazon EBS CSI driver policy to the IAM role.
resource "aws_iam_role_policy_attachment" "ebs_csi_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.NodeGroupRole.name
}

# Attach the Amazon EKS worker node policy to the IAM role.
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeGroupRole.name
}

# Attach the Amazon EC2 Container Registry ReadOnly policy to the IAM role.
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeGroupRole.name
}

# Attach the Amazon EKS CNI policy to the IAM role.
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeGroupRole.name
}

# Create an EKS node group.
resource "aws_eks_node_group" "node-ec2" {
  for_each        = { for node_group in var.node_groups : node_group.name => node_group }
  cluster_name    = var.eks_cluster_name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.NodeGroupRole.arn
  subnet_ids      = flatten([var.public_subnets_ids, var.private_subnets_ids])

  scaling_config {
    desired_size = try(each.value.scaling_config.desired_size, var.default_scaling_config.desired_size)
    max_size     = try(each.value.scaling_config.max_size, var.default_scaling_config.max_size)
    min_size     = try(each.value.scaling_config.min_size, var.default_scaling_config.min_size)
  }

  update_config {
    max_unavailable = try(each.value.update_config.max_unavailable, 1)
  }

  ami_type       = each.value.ami_type
  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
  tags = {
    Name = "${var.resource_name_prefix}${each.value.name}"
  }
}

# Create EKS addons.
resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = var.eks_cluster_name
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags = {
    Name = "${var.resource_name_prefix}addon-${each.value.name}"
  }
  depends_on = [for ng in aws_eks_node_group.node-ec2 : ng]
}

# Create an OpenID Connect provider.
resource "aws_iam_openid_connect_provider" "default" {
  url             = "https://${local.oidc}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  tags = {
    Name = "${var.resource_name_prefix}openid-connect-provider"
  }
}
