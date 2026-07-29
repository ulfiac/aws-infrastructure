terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.57.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
  }
  required_version = "1.15.8"
}
