data "aws_iam_policy_document" "key" {
  statement {
    actions   = ["kms:*"]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
}

resource "aws_kms_key" "this" {
  count = var.kms_key_id == "" ? 1 : 0

  deletion_window_in_days = 7
  description             = "Terraform State KMS key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key.json

  tags = merge(var.tags, {
    "Name" = var.kms_alias_name != null ? var.kms_alias_name : "tf_backend_key"
  })
}

resource "aws_kms_alias" "this" {
  count = var.kms_key_id == "" ? 1 : 0

  name          = "alias/${var.kms_alias_name != "" ? var.kms_alias_name : "tf_backend_key"}"
  target_key_id = aws_kms_key.this[0].id
}
