terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.55.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
    }
  }
  required_version = "1.15.7"
}
