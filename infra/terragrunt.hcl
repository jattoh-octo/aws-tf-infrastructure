locals {
    common = read_terragrunt_config(find_in_parent_folders("common.terragrunt.hcl"))
    account = read_terragrunt_config(find_in_parent_folders("account.terragrunt.hcl"))
    region = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
    environment = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))
}
remote_state {
    backend = "s3"
    # remote_state dynamically configured based on:
    # local.region.locals.aws_region
    # local.account.locals.aws_account_id
    # local.common.locals.app_name
    # ...
}
generate "provider" {
    # AWS provider dynamically configured based on:
    # local.region.locals.aws_region
    # local.account.locals.aws_account_id
    # ...
}
# The following variables apply to all configurations in this subfolder
# and are automatically merged into the child `terragrunt.hcl` config
# via the include block.
inputs = merge(
    local.common.locals,
    local.account.locals,
    local.region.locals,
    local.environment.locals
)