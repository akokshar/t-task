output "instance_profile_name" {
  value = aws_iam_instance_profile.default_instance_profile.name
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}
