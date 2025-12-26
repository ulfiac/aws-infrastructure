variable "additional_tags" {
  description = "Additional tags to merge with standard tags"
  type        = map(string)
  default     = {}
}

variable "created_by" {
  description = "Name of the entity or user that created the resource"
  type        = string
  default     = "terraform"
}

variable "project" {
  description = "Name of the project these resources belong to"
  type        = string
  default     = ""
}
