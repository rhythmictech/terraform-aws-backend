data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Namespace = "${var.namespace}"
    Owner     = "${var.owner}"
  }
}

variable "region" {
  type = "string"
}

variable "namespace" {
  type = "string"
}

variable "owner" {
  type = "string"
}

variable "extra_tags" {
  description = "Mapping of any extra tags you want added to resources"
  type        = "map"
  default     = {}
}

variable "bucket" {
  description = "Name of bucket to create"
  type        = "string"
}

variable "table" {
  description = "Name of Dynamo Table to create"
  type        = "string"
}
