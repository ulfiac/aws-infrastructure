variable "create_lambda" {
  description = "Flag to create a web app using AWS Lambda."
  type        = bool
  default     = false
}

variable "create_rds_database" {
  description = "Flag to create an Aurora or RDS database."
  type        = bool
  default     = false
}

variable "launch_ec2_instance" {
  description = "Flag to launch an instance using EC2."
  type        = bool
  default     = false
}

variable "setup_cost_budget" {
  description = "Flag to setup a cost budget using AWS Budgets."
  type        = bool
  default     = false
}

variable "use_foundation_model" {
  description = "Flag to use a foundation model in the Amazon Bedrock playground."
  type        = bool
  default     = false
}
