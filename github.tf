module "oidc-github" {
  for_each = var.github

  source  = "unfunco/oidc-github/aws"
  version = "1.5.0"

  github_organisation = each.value.org
  github_repositories = each.value.repos

  create_oidc_provider = true

  attach_admin_policy     = false
  attach_read_only_policy = false

  iam_role_name        = "github-${each.key}"
  iam_role_policy_arns = lookup(each.value, "policy_arns", [])
}
