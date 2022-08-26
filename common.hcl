# ----------------------------------------------------------------------------------------------------------------
# This is the root configuration for infrastructure-live. Its purpose is to:
#
#   - generate a provider block to configure the Terraform provider for AWS
#   - generate a remote state block for storing state in S3
#   - define a minimal set of global inputs that may be needed by any file
#
# Each module within infrastructure-live includes this file.
# ----------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------
# LOAD COMMON VARIABLES
# ----------------------------------------------------------------------------------------------------------------
locals {
  # Load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract commonly used variables for easy access
  name_prefix      = local.common_vars.locals.name_prefix
  project_name     = local.common_vars.locals.project_name
  environment_name = local.environment_vars.locals.environment_name
  account_name     = local.account_vars.locals.account_name
  profile_name     = local.account_vars.locals.profile_name
  account_id       = local.common_vars.locals.account_ids[local.account_name]
  aws_region       = local.region_vars.locals.aws_region
}

# ----------------------------------------------------------------------------------------------------------------
# GENERATED PROVIDER BLOCK
# ----------------------------------------------------------------------------------------------------------------
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "null" {}
EOF
}

# Use an override file to lock the provider version, regardless of if required_providers is defined in the modules.
generate "provider_version" {
  path      = "provider_version_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}
EOF
}


# ----------------------------------------------------------------------------------------------------------------
# DEFAULT INPUTS
# ----------------------------------------------------------------------------------------------------------------
inputs = {
  # Set globally used inputs here to keep all the child terragrunt.hcl files more DRY.
  aws_account_id = local.account_id
  aws_region     = local.aws_region
  name_prefix    = local.common_vars.locals.name_prefix
}

#-----------------------------------------------------------------------------------------------------------------
# ALLOW .terraform-version FILE TO BE COPIED
#-----------------------------------------------------------------------------------------------------------------
terraform {
  include_in_copy = [".terraform-version"]
}
