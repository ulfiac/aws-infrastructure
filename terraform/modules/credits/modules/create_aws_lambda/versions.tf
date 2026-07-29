terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.57.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.8.0"
    }
  }
  required_version = "1.15.8"
}
