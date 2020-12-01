data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  env       = "sandbox"
  name      = "example"
  namespace = "aws-rhythmic-sandbox"
  owner     = "Rhythmictech Engineering"

  extra_tags = {
    delete_me = "please"
    purpose   = "testing"
  }
}

module "tags" {
  source  = "rhythmictech/tags/terraform"
  version = "1.0.0"

  names = [local.name, local.env, local.namespace]

  tags = merge({
    "Env"       = local.env,
    "Namespace" = local.namespace,
    "Owner"     = local.owner
  }, local.extra_tags)
}

module "backend" {
  source = "../.."

  bucket = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${module.tags.name}"
  kms_alias_name = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${module.tags.name}"
  tags   = module.tags.tags
}
