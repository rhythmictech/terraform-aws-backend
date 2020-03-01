data "aws_iam_policy_document" "key" {

  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  dynamic "statement" {
    for_each = var.allowed_account_ids

    content {

      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
      ]
      effect    = "Allow"
      resources = ["*"]
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }
    }
  }

}


resource "aws_kms_key" "this" {
  count                   = var.kms_key_id == "" ? 1 : 0
  deletion_window_in_days = 7
  description             = "Terraform State KMS key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key.json
  tags = merge(
    {
      "Name" = "tf-backend-key"
    },
    var.tags
  )
}

resource "aws_kms_alias" "this" {
  count         = var.kms_key_id == "" ? 1 : 0
  name          = "alias/tf_backend_config"
  target_key_id = aws_kms_key.this[0].id
}
