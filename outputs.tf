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
