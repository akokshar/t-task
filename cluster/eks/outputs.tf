output "instance_profile_name" {
  value = aws_iam_instance_profile.default_instance_profile.name
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value = module.eks.cluster_certificate_authority_data
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}
