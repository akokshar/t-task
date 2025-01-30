variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "additional_tags" {
  type = map(string)
}

variable "cluster_endpoint_public_access" {
  type = bool
  default = false
}

variable "cluster_endpoint_public_access_cidrs" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "cluster_endpoint_private_access" {
  type = bool
  default = true
}

variable "managed_ng_capacity_type" {
  type = string
}

variable "managed_ng_instance_types" {
 type = list(string)
}

variable "aws_managed_node_group_arch" {
  type = string
  default = "arm64"
}

variable "ebs_volume_size" {
  type = number
  default = 50
}
