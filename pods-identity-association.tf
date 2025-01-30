data "aws_iam_policy_document" "pod_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "karpenter" {
  name               = format("%s-%s-karpenter-pod-identity", local.environemnt, loca.name)
  assume_role_policy = data.aws_iam_policy_document.pod_assume_role.json
}

resource "aws_iam_role_policy_attachment" "karpenter" {
  policy_arn = aws_iam_policy.karpenter.arn
  role       = aws_iam_role.karpenter.name
}

resource "aws_eks_pod_identity_association" "karpenter" {
  cluster_name    = module.eks.cluster_name
  namespace       = "karpenter"
  service_account = "karpenter"
  role_arn        = aws_iam_role.karpenter.arn
}
