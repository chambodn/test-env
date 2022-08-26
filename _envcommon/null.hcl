# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for networking/route53-public. The common variables for each environment to
# deploy networking/route53-public are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If you're iterating
# locally, you can use --terragrunt-source /path/to/local/checkout/of/module to override the source parameter to a
# local check out of the module for faster iteration.
terraform {
  source = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Extract the public_root_domain_name for easy access
  public_root_domain_name = local.environment_vars.locals.public_root_domain.name

  common_vars                             = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  mock_outputs_allowed_terraform_commands = local.common_vars.locals.mock_outputs_allowed_terraform_commands
}

dependency "dns" {
  config_path = "${get_terragrunt_dir()}/../../../_global/dns/route53-public"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = local.mock_outputs_allowed_terraform_commands

  mock_outputs = {
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above.
# This defines the parameters that are common across all environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  acm_tls_certificates = {
    "data.${local.continent}.${local.public_root_domain_name}" = {
      subject_alternative_names = ["*.data.${local.continent}.${local.public_root_domain_name}"]

      create_verification_record = true
      verify_certificate         = true
      # This is the ID of the public zone example.com
      hosted_zone_id = lookup(dependency.dns.outputs.public_hosted_zone_map, "data.${local.continent}.${local.public_root_domain_name}", null)
    }
  }
}
