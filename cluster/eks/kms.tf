module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "3.1.0"
  deletion_window_in_days = 7
  description             = "Symetric Key to Enable Encryption at rest using KMS services."
  key_usage               = "ENCRYPT_DECRYPT"

  # Policy
  enable_default_policy = true
  key_owners            = [data.aws_caller_identity.this.arn]
  key_administrators = [
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS",
    data.aws_caller_identity.this.arn
  ]
  key_users = [
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS",
    data.aws_caller_identity.this.arn
  ]
  key_service_users = [
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS",
    data.aws_caller_identity.this.arn
  ]
  key_symmetric_encryption_users         = [data.aws_caller_identity.this.arn]
  key_hmac_users                         = [data.aws_caller_identity.this.arn]
  key_asymmetric_public_encryption_users = [data.aws_caller_identity.this.arn]
  key_asymmetric_sign_verify_users       = [data.aws_caller_identity.this.arn]
  key_statements = [
    {
      sid    = "AllowCloudWatchLogsEncryption",
      effect = "Allow"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${var.aws_region}.amazonaws.com"]
        }
      ]
    }
  ]
  # Aliases
  aliases                 = [format("%s-%s-KMS", var.environment, var.name)]
  aliases_use_name_prefix = true
}

