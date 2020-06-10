data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id

  # Account IDs that will have access to stream CloudTrail logs
  account_ids = concat([local.account_id], var.allowed_account_ids)

  # Format account IDs into necessary resource lists.
  iam_account_principals = formatlist("arn:aws:iam::%s:root", local.account_ids)

  # Resolve resource names
  bucket     = var.remote_bucket == "" ? aws_s3_bucket.this[0].id : var.remote_bucket
  kms_key_id = var.kms_key_id == "" ? aws_kms_key.this[0].arn : var.kms_key_id
}

resource "aws_s3_bucket" "this" {
  count  = var.remote_bucket == "" ? 1 : 0
  bucket = var.bucket
  acl    = "log-delivery-write"
  tags = merge(
    var.tags,
    {
      "Name" = "tf-state"
    },
  )

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = local.kms_key_id
      }
    }
  }

  logging {
    target_bucket = coalesce(var.logging_target_bucket, var.bucket)
    target_prefix = var.logging_target_prefix
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.remote_bucket == "" ? 1 : 0
  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "this" {
  name         = var.table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      "Name" = "tf-locktable"
    },
  )
}


data "aws_iam_policy_document" "this" {


  statement {
    actions = [
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${local.bucket}"
    ]

    principals {
      type        = "AWS"
      identifiers = local.iam_account_principals
    }
  }

  dynamic "statement" {
    for_each = var.allowed_account_ids

    content {

      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      effect    = "Allow"
      resources = ["arn:aws:s3:::${local.bucket}/${statement.value}/*"]

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.remote_bucket == "" ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.this.json
}
