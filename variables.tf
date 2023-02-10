variable "bucket_name" {
  description = "Name of bucket to hold tf state"
  type        = string
}

variable "dynamo_locktable_name" {
  default     = "tf-locktable"
  description = "Name of lock table for terraform"
  type        = string
}

variable "dynamodb_kms_key_arn" {
  default     = null
  description = "KMS key arn to enable encryption on dynamodb table. Defaults to `alias/aws/dynamodb`"
  type        = string
}

variable "dynamodb_point_in_time_recovery" {
  default     = true
  description = "DynamoDB point-in-time recovery."
  type        = bool
}

variable "dynamodb_server_side_encryption" {
  default     = true
  description = "Bool to enable encryption on dynamodb table"
  type        = bool
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
  default     = null
  description = "lifecycle rules to apply to the bucket (set to null to skip lifecycle rules)"

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

variable "tags" {
  default     = {}
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
}

########################################
# Assume Role Template Vars
########################################
variable "create_assumerole_template" {
  default     = false
  description = "If true, create a CloudFormation template that can be run against accounts to create an assumable role"
  type        = bool
}

variable "assumerole_role_name" {
  default     = "Terraform"
  description = "Name of role to create in assumerole template"
  type        = string
}

variable "assumerole_role_external_id" {
  default     = null
  description = "External ID to attach to role (this is required, a random ID will be generated if not specified here)"
  type        = string
}

variable "assumerole_role_attach_policies" {
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  description = "Policy ARNs to attach to role (can be managed or custom but must exist)"
  type        = list(string)
}

variable "assumerole_stack_name" {
  default     = "tf-assumerole"
  description = "Name of CloudFormation stack"
  type        = string
}

variable "assumerole_template_name" {
  default     = "assumerole/tfassumerole.cfn.yml"
  description = "File name of assumerole cloudformation template"
  type        = string
}
