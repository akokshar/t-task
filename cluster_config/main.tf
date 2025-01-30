resource "kubernetes_manifest" "karpenter_nodeclass" {
  manifest = yamldecode(templatefile("${path.module}/templates/karpenter-nodeclass.yaml", {
    name: var.name
    environment: var.environment
    cluster_name: var.cluster_name
    security_groups: []
    instance_profile: var.instance_profile_name
  }))
}

resource "kubernetes_manifest" "karpenter_nodepool_x86" {
  manifest = yamldecode(templatefile("${path.module}/templates/karpenter-nodepool-x86.yaml", {
    name: format("%s-x86", var.name)
    nodeclass_name: var.name
  }))
}

resource "kubernetes_manifest" "karpenter_nodepool_arm" {
  manifest = yamldecode(templatefile("${path.module}/templates/karpenter-nodepool-arm.yaml", {
    name: format("%s-arm", var.name)
    nodeclass_name: var.name
  }))
}
