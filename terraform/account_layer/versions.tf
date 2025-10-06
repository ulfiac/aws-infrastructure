terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.15.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
  required_version = ">= 1.13.1"
}
