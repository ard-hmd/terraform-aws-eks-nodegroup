# Prefix for resource names
variable "resource_name_prefix" {
  description = "Prefix for the names of resources"
  type        = string
  default     = "terraform-aws-eks-nodegroup-"
}

# List of EKS addons with their names and versions
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.27.4-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.15.0-eksbuild.2"
    },
    {
      name    = "coredns"
      version = "v1.10.1-eksbuild.4"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.22.0-eksbuild.2"
    }
  ]
}

# The name of the EKS cluster
variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}


# Default scaling configuration for the EKS node group
variable "default_scaling_config" {
  description = "Default scaling configuration for the EKS node group"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
  default = {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

# List of node groups for the EKS cluster
variable "node_groups" {
  description = "List of node groups for the EKS cluster"
  type = list(object({
    name           = string
    ami_type       = string
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    scaling_config = optional(object({
      desired_size = number
      max_size     = number
      min_size     = number
    }))
  }))
  default = []
}

# The IDs of the public subnets in the existing VPC
variable "public_subnets_ids" {
  description = "The IDs of the public subnets in the existing VPC"
  type        = list(string)
}

# The IDs of the private subnets in the existing VPC
variable "private_subnets_ids" {
  description = "The IDs of the private subnets in the existing VPC"
  type        = list(string)
}
