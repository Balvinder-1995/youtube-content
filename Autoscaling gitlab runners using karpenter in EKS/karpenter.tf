module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  cluster_name = "balvinder"
}


resource "helm_release" "karpenter" {
  name = "karpenter"
  namespace = "kube-system"
  chart = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"

set = [ {
  name = "settings.clusterName"
    value = "balvinder"
  }, {
    name = "settings.interruptionQueue"
    value = "balvinder"
  }
]
}