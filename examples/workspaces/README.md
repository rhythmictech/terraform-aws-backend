# Workspaces Backend Example
Creates resources for a secure backend in AWS to support multiple AWS accounts. To use this backend with accounts managed by Terraform workspaces, use the following provider definition and variable:

```
provider "aws" {
  region = var.region

  assume_role {
    role_arn    = var.workspace_iam_roles[terraform.workspace].role_arn
    external_id = var.workspace_iam_roles[terraform.workspace].external_id
  }
}

variable "workspace_iam_roles" {
  description = "IAM roles to assume"
  type        = any
}

```

Then define variable entries for each account:

```
workspace_iam_roles = {
  dev = {
    role_arn    = "arn:aws-us-gov:iam::012345678901:role/Terraform"
    external_id = "YourExternalID"
  }
  test = {
    role_arn    = "arn:aws:iam::012345678902:role/Terraform"
    external_id = "YourExternalID"
  }
  prod = {
    role_arn    = "arn:aws-us-gov:iam::012345678903:role/Terraform"
    external_id = "YourExternalID"
  }
}
```

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
