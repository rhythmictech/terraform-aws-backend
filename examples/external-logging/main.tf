
locals {
  env       = "sandbox"
  name      = "example"
  namespace = "aws-rhythmic-sandbox"
  owner     = "Rhythmictech Engineering"
  region    = "us-east-1"

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

module "bucket" {
  source        = "rhythmictech/s3logging-bucket/aws"
  version       = "2.0.0"
  bucket_suffix = "tfstate-logging"
}

module "backend" {
  source                = "../.."
  logging_target_bucket = module.bucket.s3_bucket_name
}
