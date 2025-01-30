terraform {
  backend "s3" {
    bucket         = "test-42782cc1-0456-4125-9303-fed1b79d84e5"
    key            = "terraform.tfstate"
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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }

  }

  required_version = ">= 1.9.8"
}

