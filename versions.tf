
terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.22.0, < 7.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
