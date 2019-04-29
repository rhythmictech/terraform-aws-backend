resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.bucket}"
  acl    = "private"

  tags = "${merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "tf-state"
    )
  )}"

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
        sse_algorithm = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = "${var.bucket}"
    target_prefix = "TFStateLogs/"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = "${aws_s3_bucket.config_bucket.id}"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name         = "${var.table}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = "${merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "tf-locktable"
    )
  )}"
}
