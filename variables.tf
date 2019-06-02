data "aws_caller_identity" "current" {
}

locals {
  common_tags = {
    namespace = var.namespace
    owner     = var.owner
    env       = var.env
  }
}

variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "owner" {
  type = string
}

variable "env" {
  type    = string
  default = "global"
}

variable "extra_tags" {
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
  default = {
  }
}

variable "bucket" {
  description = "Name of bucket to create"
  type        = string
}

variable "table" {
  description = "Name of Dynamo Table to create"
  type        = string
}

