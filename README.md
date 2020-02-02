# terraform-aws-backend

[![](https://github.com/rhythmictech/terraform-aws-backend/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-backend/actions)

Creates a backend S3 bucket and DynamoDB table for managing Terraform state. Useful for bootstrapping a new
environment.

## Usage
```
module "backend" {
  source    = "git::ssh://git@github.com/rhythmictech/terraform-aws-backend"
  bucket    = "project-tfstate"
  region    = "us-east-1"
  table     = "tf-locktable"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket | Name of bucket to create | string | n/a | yes |
| region | Region bucket will be created in | string | n/a | yes |
| table | Name of Dynamo Table to create | string | n/a | yes |
| tags | Mapping of any extra tags you want added to resources | map(string) | `{}` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
