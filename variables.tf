data "aws_caller_identity" "current" {
}

variable "bucket" {
  description = "Name of bucket to create"
  type        = string
}

variable "region" {
  type = string
}

variable "table" {
  description = "Name of Dynamo Table to create"
  type        = string
}

variable "tags" {
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
  default = {
  }
}
