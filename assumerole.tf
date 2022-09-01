locals {
  external_id = coalesce(var.assumerole_role_external_id, random_password.external_id.result)
}

resource "local_file" "assumerole_addrole" {
  count = var.create_assumerole_template ? 1 : 0

  filename = "assumerole/addrole.sh"

  content = templatefile("${path.module}/template/addrole.sh.tftpl", {
    stack_name = var.assumerole_stack_name
  })

}

resource "local_sensitive_file" "assumerole_tfassumerole" {
  count = var.create_assumerole_template ? 1 : 0

  filename = "assumerole/tfassumerole.cfn.yml"

  content = templatefile("${path.module}/template/tfassumerole.cfn.yml.tftpl", {
    external_id       = local.external_id
    parent_account_id = local.account_id
    partition         = local.partition
    policy_arns       = var.assumerole_role_attach_policies
    role_name         = var.assumerole_role_name
  })

}

# not used if an external id is specified
resource "random_password" "external_id" {
  length           = 16
  special          = true
  override_special = "-_=+"
}
