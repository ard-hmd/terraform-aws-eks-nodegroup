# Module Terraform AWS EKS Node Group

This Terraform module allows for the deployment of an EKS Node Group in AWS with associated IAM configurations. It's designed to offer maximum flexibility to cater to specific EKS Node Group deployment needs.

## Features

- **IAM Role for EKS Node Group**: Creates a specific IAM role for the node group and attaches necessary IAM policies.
- **EKS Addons Management**: Allows for defining and managing EKS addons for the cluster.
- **Scaling Configuration**: Offers flexibility in defining the scaling configuration for the node group.
- **Custom Tagging**: Supports adding tags with a custom prefix for easy resource identification.

## Usage

```hcl
module "eks_node_group" {
  source            = "github.com/ard-hmd/terraform-aws-eks-nodegroup.git"
  eks_cluster_name  = "my-eks-cluster"

  default_scaling_config = {
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }

  node_groups       = [
    {
      name           = "node-group-1",
      ami_type       = "AL2_x86_64",
      instance_types = ["t3.medium"],
      capacity_type  = "ON_DEMAND",
      disk_size      = 20
    }
  ]
  public_subnets_ids  = ["subnet-x", "subnet-x"]
  private_subnets_ids = ["subnet-x", "subnet-x"]
}
```

## Variables

- `resource_name_prefix`: Prefix for resource names. Default: `terraform-aws-eks-nodegroup-`.
- `eks_cluster_name`: Name of the EKS cluster.
- `node_groups`: List of node groups for the EKS cluster.
- `default_scaling_config`: Default scaling configuration for the EKS node group.
- `public_subnets_ids`: The IDs of the existing VPC's public subnets.
- `private_subnets_ids`: The IDs of the existing VPC's private subnets.
- `addons`: List of EKS addons with their versions.

## Outputs

- `node_group_arns`: The Amazon Resource Names (ARNs) of the EKS Node Groups.
- `node_group_ids`: The EKS Node Group IDs.
- `node_group_statuses`: The statuses of the EKS Node Groups.
- `node_group_roles`: The IAM roles associated with the EKS Node Groups.
- `openid_connect_provider_url`: The URL of the IAM OIDC provider for the EKS cluster.
