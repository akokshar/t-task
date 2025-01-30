terraform {
  backend "s3" {
    bucket         = "test-42782CC1-0456-4125-9303-FED1B79D84E5"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    #dynamodb_table = "tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }

  }

  required_version = ">= 1.9.8"
}

