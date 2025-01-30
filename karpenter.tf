resource "aws_iam_policy" "karpenter" {
  name        = format("%s-%s-karpenter", local.environment, local.name)
  description = "Allows karpenter to manage instances"

  depends_on = [module.eks]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts",
          "iam:CreateServiceLinkedRole"
        ],
        Effect   = "Allow",
        Resource = "*",
        Sid      = "Karpenter"
      },
      {
        Action = [
          "ec2:TerminateInstances"
        ],
        Condition = {
          "StringLike" : {
            "ec2:ResourceTag/karpenter.sh/managed-by" : "${module.eks.cluster_name}"
          }
        },
        Effect   = "Allow",
        Resource = "*",
        Sid      = "ConditionalEC2Termination"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = aws_iam_role.node.arn
        Sid      = "PassNodeIAMRole"
      },
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster"
        ],
        Resource = "arn:aws:eks:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:cluster/${module.eks.cluster_name}",
        Sid      = "EKSClusterEndpointLookup"
      }
    ]
  })
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.2.0"
  wait       = true

  create_namespace = true
  namespace        = "karpenter"

  values = [
    templatefile("${path.module}/templates/karpenter-values.yaml", {
      cluster_name : module.eks.cluster_name
      cluster_endpoint : module.eks.cluster_endpoint
    })
  ]
}

resource "kubernetes_manifest" "karpenter_nodeclass" {
  depends_on = [ helm_release.karpenter ]

  manifest = yamlencode(tepmlatefile("${path.module}/templates/karpenter-nodeclass.yaml", {
    name: local.name
    environment: local.environment
    cluster_name: module.eks.cluster_name
    security_groups: []
    instance_profile: aws_instance_profile.default_instance_profile.name
  }))
}

resource "kubernetes_resource" "karpenter_nodepool_x86" {
  depends_on = [ helm_release.karpenter ]

  manifest = yamlencode(tepmlatefile("${path.module}/templates/karpenter-nodepool-x86.yaml", {
    name: format("%s-x86", local.name)
    nodeclass_name: local.name
  }))
}

resource "kubernetes_resource" "karpenter_nodepool_arm" {
  depends_on = [ helm_release.karpenter ]

  manifest = yamlencode(tepmlatefile("${path.module}/templates/karpenter-nodepool-arm.yaml", {
    name: format("%s-arm", local.name)
    nodeclass_name: local.name
  }))
}
