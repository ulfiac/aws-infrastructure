terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.26.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.6.1"
    }
  }
  required_version = ">= 1.14.2"
}
