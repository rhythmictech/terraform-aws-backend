
output "external_id" {
  description = "External ID attached to IAM role in managed accounts"
  value       = local.external_id
}

output "kms_key_arn" {
  description = "ARN of KMS Key for S3 bucket"
  value       = try(aws_kms_key.this[0].arn, var.kms_key_id)
}

output "s3_bucket_backend" {
  description = "S3 bucket used to store TF state"
  value       = aws_s3_bucket.this.bucket
}

##########################################
# stubs
##########################################

output "backend_config_stub" {
  description = "Backend config stub to be used in child account(s)"
  value       = <<EOF
bucket         = "${aws_s3_bucket.this.bucket}"
dynamodb_table = "${aws_dynamodb_table.this.name}"
region         = "${local.region}"
EOF
}

output "provider_config_stub" {
  description = "Provider config stub to be used in child account(s)"
  value       = <<EOF
provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::REPLACE_WITH_CHILD_ACCT_ID:role/${var.assumerole_role_name}"
    session_name = "terraform-network"
    external_id  = "${local.external_id}"
  }
}
EOF
}
