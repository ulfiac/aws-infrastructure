variable "availability_zone_count" {
  description = "The number of availability zones to use for the VPC."
  type        = number
  default     = 3
}

variable "log_bucket_arn" {
  description = "ARN of the S3 bucket to store logs"
  type        = string
}

variable "namespace" {
  description = "The namespace for the VPC."
  type        = string
}

# variable "enable_public_subnets" {
#   description = "Enable or disable the creation of public subnets."
#   type        = bool
#   default     = true
# }

# variable "enable_private_subnets" {
#   description = "Enable or disable the creation of private subnets."
#   type        = bool
#   default     = true
# }

# variable "enable_isolated_subnets" {
#   description = "Enable or disable the creation of isolated subnets."
#   type        = bool
#   default     = true
# }

variable "verbose_output" {
  description = "Enable verbose output for debugging purposes."
  type        = bool
  default     = false
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "Must be a valid IPv4 CIDR block format."
  }

  validation {
    condition = anytrue([
      can(regex("^10\\.", var.vpc_cidr_block)),
      can(regex("^172\\.(1[6-9]|2[0-9]|3[0-1])\\.", var.vpc_cidr_block)),
      can(regex("^192\\.168\\.", var.vpc_cidr_block))
    ])
    error_message = "The VPC CIDR block must reside in private IP space."
  }

}
