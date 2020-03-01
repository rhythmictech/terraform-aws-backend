variable "allowed_account_ids" {
  default     = []
  description = "Account IDs that are allowed to access the bucket/KMS key"
  type        = list(string)
}

variable "bucket" {
  default     = ""
  description = "Name of bucket to create (do not provide if using `remote_bucket`)"
  type        = string
}

variable "kms_key_id" {
  default     = ""
  description = "ARN for KMS key for all encryption operations."
  type        = string
}

variable "region" {
  description = "Region bucket will be created in"
  type        = string
}

variable "remote_bucket" {
  default     = ""
  description = "If specified, the remote bucket will be used for the backend. A new bucket will not be created"
  type        = string
}

variable "table" {
  default     = "tf-locktable"
  description = "Name of Dynamo Table to create"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
}
