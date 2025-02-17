data "aws_eks_cluster" "cluster" {
  depends_on = [ module.eks ]
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  depends_on = [ module.eks ]
  name = module.eks.cluster_name
}

provider "aws" {
  region = "eu-west-2"
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
