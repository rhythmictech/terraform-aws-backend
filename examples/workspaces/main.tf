module "tfstate" {
  source = "../.."

  bucket_name                = "tf-state-remote"
  create_assumerole_template = true
  dynamo_locktable_name      = "tf-locktable-remote"
}
