# terraform-aws-backend

[![](https://github.com/rhythmictech/terraform-aws-backend/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-backend/actions)

Creates a backend S3 bucket and DynamoDB table for managing Terraform state. Useful for bootstrapping a new
environment. This module supports cross-account state management, using a centralized account that holds the S3 bucket and KMS key.

_Note: A centralized DynamoDB locking table is not supported because terraform cannot assume more than one IAM role per execution._

## Usage
```
module "backend" {
  source    = "git::ssh://git@github.com/rhythmictech/terraform-aws-backend"
  bucket    = "project-tfstate"
  region    = "us-east-1"
  table     = "tf-locktable"
}

```

## Cross Account State Management
Managing state across accounts requires additional configuration to ensure that the S3 bucket is appropriately accessible and the KMS key is usable.

The following module declaration will create an S3 bucket and KMS key that are accessible to the root account (and users with the AdministratorAccess managed role) in the target account:

```yaml
module "backend" {
  source    = "git::ssh://git@github.com/rhythmictech/terraform-aws-backend"
  allowed_account_ids = ["123456789012"]
  bucket              = "012345678901-us-east-1-tfstate"
  region              = "us-east-1"
}
```

In the target account, use this declaration to import the module:

```yaml
module "backend" {
  source    = "git::ssh://git@github.com/rhythmictech/terraform-aws-backend"
  kms_key_id               = "arn:aws:kms:us-east-1:012345678901:key/59381274-af42-8521-04af-ab0acfe3d521"
  region                   = "us-east-1"
  remote_bucket            = "012345678901-us-east-1-tfstate"
}
```

The module will automatically write to the source account S3 bucket using the KMS key with cross-account access.

Access to the source S3 bucket is done based on a prefix that matches the AWS Account ID. Therefore, target accounts must use a `workspace_key_prefix` that matches the account ID, such as in the following sample backend-config values:

```
bucket               = "012345678901-us-east-1-tf-state"
key                  = "project.tfstate"
workspace_key_prefix = "123456789012"
region               = "us-east-1"
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed\_account\_ids | Account IDs that are allowed to access the bucket/KMS key | list(string) | `[]` | no |
| bucket | Name of bucket to create \(do not provide if using `remote_bucket`\) | string | `""` | no |
| kms\_key\_id | ARN for KMS key for all encryption operations. | string | `""` | no |
| region | Region bucket will be created in | string | n/a | yes |
| remote\_bucket | If specified, the remote bucket will be used for the backend. A new bucket will not be created | string | `""` | no |
| table | Name of Dynamo Table to create | string | `"tf-locktable"` | no |
| tags | Mapping of any extra tags you want added to resources | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_key\_arn | ARN of KMS Key for S3 bucket |
| s3\_bucket\_backend | S3 bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
