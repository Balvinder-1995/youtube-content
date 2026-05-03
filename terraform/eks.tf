module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "21.19.0"
  name = "${var.name}-eks"
  kubernetes_version = "1.35"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  endpoint_private_access = false
  endpoint_public_access = true
  access_entries = {
    admin = {
      kubernetes_group = []
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_AdministratorAccess_dfcc7130c089a58d"
      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  eks_managed_node_groups = {
    "bottlerocket" = {
      ami_type = "BOTTLEROCKET_x86_64"
      capacity_type = "ON_DEMAND"
      create_iam_role = true
      instance_types = ["t3.medium"]
      min_size = 2
      max_size = 2
      desired_size = 2
    }
  }
  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      before_compute = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
}