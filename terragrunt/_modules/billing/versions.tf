terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.26.0" # current as of 2025-12-16
    }
  }
  required_version = ">= 1.14.2" # current as of 2025-12-16
}
