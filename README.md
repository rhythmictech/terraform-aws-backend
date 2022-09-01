# terraform-aws-backend

[![tflint](https://github.com/rhythmictech/terraform-aws-backend/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-backend/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-backend/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-backend/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-backend/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-backend/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-backend/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-backend/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-backend/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-backend/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

Creates a backend S3 bucket and DynamoDB table for managing Terraform state. Note that when bootstrapping a new environment, it is typically easier to use a separate method for creating the bucket and lock table. This module is intended to create a backend in an AWS account that is already Terraform-managed. This is useful to store the state for other accounts externally, which is always preferred.

*Breaking Changes*

Previous versions of this module had support for cross-account management in a way that proved awkward for many uses cases and made it more difficult than it should've to fully secure the tfstate between accounts. Version 4.x and later eliminates support for this and refocuses the module on using centralized tfstate buckets with cross-account role assumption for execution of terraform. As a result, many variable names have changed and functionality has been dropped. Upgrade to this version at your own peril.

## Usage
```
module "backend" {
  source    = "rhythmictech/backend/aws"
  
  bucket    = "project-tfstate"
  region    = "us-east-1"
  table     = "tf-locktable"
}
```

## Cross Account State Management
To use this bucket to manage the state for other AWS accounts, you must create IAM roles in those accounts and allow the users who run Terraform to assume them.

See [Use AssumeRole to Provision AWS Resources Across Accounts](https://learn.hashicorp.com/tutorials/terraform/aws-assumerole) for more information on this pattern.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning_example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_iam_policy_document.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of bucket to create | `string` | n/a | yes |
| <a name="input_kms_alias_name"></a> [kms\_alias\_name](#input\_kms\_alias\_name) | Name of KMS Alias | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN for KMS key for all encryption operations (a key will be created if this is not provided) | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | lifecycle rules to apply to the bucket (set to null to skip lifecycle rules) | <pre>list(object(<br>    {<br>      id                            = string<br>      enabled                       = bool<br>      prefix                        = string<br>      expiration                    = number<br>      noncurrent_version_expiration = number<br>  }))</pre> | <pre>[<br>  {<br>    "enabled": true,<br>    "expiration": 90,<br>    "id": "tfstate-expire",<br>    "noncurrent_version_expiration": 90,<br>    "prefix": null<br>  }<br>]</pre> | no |
| <a name="input_logging_target_bucket"></a> [logging\_target\_bucket](#input\_logging\_target\_bucket) | The name of the bucket that will receive the log objects (logging will be disabled if null) | `string` | `null` | no |
| <a name="input_logging_target_prefix"></a> [logging\_target\_prefix](#input\_logging\_target\_prefix) | A key prefix for log objects | `string` | `null` | no |
| <a name="input_table"></a> [table](#input\_table) | Name of Dynamo Table to create | `string` | `"tf-locktable"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Mapping of any extra tags you want added to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of KMS Key for S3 bucket |
| <a name="output_s3_bucket_backend"></a> [s3\_bucket\_backend](#output\_s3\_bucket\_backend) | S3 bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
