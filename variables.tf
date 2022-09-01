variable "bucket_name" {
  description = "Name of bucket to create"
  type        = string
}

variable "kms_alias_name" {
  default     = null
  description = "Name of KMS Alias"
  type        = string
}

variable "kms_key_id" {
  default     = null
  description = "ARN for KMS key for all encryption operations (a key will be created if this is not provided)"
  type        = string
}

variable "lifecycle_rules" {
  description = "lifecycle rules to apply to the bucket (set to null to skip lifecycle rules)"

  default = [{
    id                            = "tfstate-expire"
    enabled                       = true
    expiration                    = 90
    noncurrent_version_expiration = 90
    prefix                        = null
  }]

  type = list(object(
    {
      id                            = string
      enabled                       = bool
      prefix                        = string
      expiration                    = number
      noncurrent_version_expiration = number
  }))
}

variable "logging_target_bucket" {
  default     = null
  description = "The name of the bucket that will receive the log objects (logging will be disabled if null)"
  type        = string
}

variable "logging_target_prefix" {
  default     = null
  description = "A key prefix for log objects"
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
