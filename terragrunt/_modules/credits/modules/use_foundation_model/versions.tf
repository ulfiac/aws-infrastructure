terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.24.0" # current as of 2025-12-03
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.7.1" # current as of 2025-12-03
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.7.2" # current as of 2025-12-03
    }
  }
  required_version = ">= 1.14.1" # current as of 2025-12-03
}
