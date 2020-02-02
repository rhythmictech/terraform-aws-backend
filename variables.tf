variable "bucket" {
  description = "Name of bucket to create"
  type        = string
}

variable "region" {
  description = "Region bucket will be created in"
  type        = string
}

variable "table" {
  description = "Name of Dynamo Table to create"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
}
