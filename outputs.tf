output "s3_bucket_backend" {
  description = "S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "kms_key_arn" {
  description = "ARN of KMS Key for S3 bucket"
  value       = try(aws_kms_key.this[0].arn, var.kms_key_id)
}
