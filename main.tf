data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Resolve resource names
  bucket_name = try(var.bucket_name, "${local.account_id}-${local.region}-tfstate")
  kms_key_id  = try(aws_kms_key.this[0].arn, var.kms_key_id)
}

data "aws_canonical_user_id" "current" {}

# tfsec is not yet smart enough to know new tf syntax for crypto/logging
#tfsec:ignore:AWS017 #tfsec:ignore:AWS002
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  tags = merge(var.tags, {
    "Name" = local.bucket_name
  })
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.lifecycle_rules == null ? 0 : 1

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    iterator = rule
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = lookup(rule.value, "prefix", null)
      }

      expiration {
        days = lookup(rule.value, "expiration", 2147483647)
      }

      noncurrent_version_expiration {
        noncurrent_days = lookup(rule.value, "noncurrent_version_expiration", 2147483647)
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_logging" "this" {
  count = var.logging_target_bucket == null ? 0 : 1

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "this" {
  name         = var.table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  tags = merge(var.tags, {
    "Name" = var.table
  })

  attribute {
    name = "LockID"
    type = "S"
  }
}
