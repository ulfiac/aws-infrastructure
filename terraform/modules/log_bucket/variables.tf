variable "enable_vpc_flow_logs" {
  description = "Whether to enable VPC Flow Logs for this log bucket"
  type        = bool
  default     = true
}

variable "enable_cloudtrail_logs" {
  description = "Whether to enable CloudTrail Logs for this log bucket"
  type        = bool
  default     = false
}
