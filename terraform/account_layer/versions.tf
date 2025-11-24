terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.21.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.6.1"
    }
  }
  required_version = ">= 1.13.1"
}
