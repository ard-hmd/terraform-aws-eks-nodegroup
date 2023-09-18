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

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_groups" {
  description = "List of node groups for the EKS cluster"
  type        = list(object({
    name = string
    ami_type = string
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    # Ajoutez d'autres attributs si nécessaire
  }))
  default     = []
}

variable "public_subnets_ids" {
  description = "The IDs of the public subnets in the existing VPC"
  type        = list(string)
}

variable "private_subnets_ids" {
  description = "The IDs of the private subnets in the existing VPC"
  type        = list(string)
}
