#  Basic Backend Example
Creates resources for a secure backend in AWS to support separate AWS accounts. To use this backend, use the following provider definition:

```
provider "aws" {
  region = var.region

  assume_role {
    role_arn    = "arn:aws-us-gov:iam::012345678901:role/Terraform"
    external_id = "YourExternalID"
  }
}

You will need to run Terraform with IAM credentials of the account that holds the state rather than the accounts that you are working on.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tfstate"></a> [tfstate](#module\_tfstate) | ../.. | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
