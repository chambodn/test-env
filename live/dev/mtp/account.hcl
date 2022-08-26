# Set account-wide variables
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Get metadata from environment
  environment_name = local.environment_vars.locals.environment_name

  # Set account-level vars
  account_label = "mtp"
  account_name  = "${local.environment_name}-${local.account_label}"
  profile_name  = "${local.environment_name}-mtp-tf"
}
