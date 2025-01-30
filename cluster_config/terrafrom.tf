terraform {
  backend "s3" {
    bucket         = "test-42782cc1-0456-4125-9303-fed1b79d84e5"
    key            = "cluster-config.tfstate"
    region         = "eu-west-2"
    #dynamodb_table = "tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "= 2.35.1"
    }
  }

  required_version = ">= 1.9.8"
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

provider "aws" {
  region = "eu-west-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #load_config_file       = false
  #exec {
  #  api_version = "client.authentication.k8s.io/v1beta1"
  #  args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  #  command     = "aws"
  #}
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
