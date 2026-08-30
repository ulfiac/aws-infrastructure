variable "availability_zone_count" {
  description = "The number of availability zones to use for the VPC."
  type        = number
  default     = 3

  # these subnets are ALB-only, and AWS requires ALB subnets to span at least 2 AZs
  validation {
    condition     = var.availability_zone_count == floor(var.availability_zone_count) && var.availability_zone_count >= 2
    error_message = "availability_zone_count must be a whole number of at least 2."
  }
}

variable "log_bucket_arn" {
  description = "ARN of the S3 bucket to store logs"
  type        = string
}

variable "namespace" {
  description = "The namespace for the VPC."
  type        = string
}

variable "public_cidr_block" {
  description = "The CIDR block to carve up into public subnets, one per availability zone."
  type        = string

  validation {
    condition     = can(cidrhost(var.public_cidr_block, 0))
    error_message = "Must be a valid IPv4 CIDR block format."
  }

  validation {
    condition = try(
      tonumber(split("/", var.public_cidr_block)[1]) >= tonumber(split("/", var.vpc_cidr_block)[1]) &&
      cidrhost(var.vpc_cidr_block, 0) == cidrhost("${cidrhost(var.public_cidr_block, 0)}/${split("/", var.vpc_cidr_block)[1]}", 0),
      false
    )
    error_message = "public_cidr_block must be contained within vpc_cidr_block."
  }
}

variable "public_subnet_mask" {
  description = "The subnet mask (prefix length) used when carving public_cidr_block into individual public subnets, e.g. 24 for a /24."
  type        = number

  validation {
    condition = try(
      var.public_subnet_mask > tonumber(split("/", var.public_cidr_block)[1]) &&
      can(cidrsubnet(var.public_cidr_block, var.public_subnet_mask - tonumber(split("/", var.public_cidr_block)[1]), 0)),
      false
    )
    error_message = "Must be a valid prefix length (1-32) that is strictly more specific than public_cidr_block."
  }

  # AWS allows a public subnet to be between /16 and /28
  # AWS requires ALB subnets to be /27 or larger (a /28 only has 11 usable IPs after AWS's reserved 5)
  validation {
    condition     = var.public_subnet_mask >= 16 && var.public_subnet_mask <= 27
    error_message = "public_subnet_mask must be between 16 and 27; these subnets are ALB-only and AWS requires /27 or larger for ALB subnets."
  }

  validation {
    condition     = try(pow(2, var.public_subnet_mask - tonumber(split("/", var.public_cidr_block)[1])) >= var.availability_zone_count, false)
    error_message = "public_subnet_mask must be small enough to carve out at least availability_zone_count sub-blocks from public_cidr_block."
  }
}

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
