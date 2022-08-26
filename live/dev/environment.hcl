# Common variables for an environment
locals {
  environment_name = "dev"

  public_root_domain = {
    name = "${local.environment_name}.nexthink.cloud"
    # Hardcoded, should be a terragrunt dependency at some point.
  }

  # Whether or not we restrict public endpoint to Nexthink internal IPs
  restrict_public_endpoint = true
}
