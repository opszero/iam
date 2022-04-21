module "aws_oidc_gitlab" {

  for_each = var.gitlab
  source   = "git::https://github.com/thaunghtike-share/terraform-aws-oidc-gitlab.git?ref=main"


  attach_admin_policy  = false
  create_oidc_provider = true
  iam_role_name        = "gitlab_oidc_role"
  iam_policy_arns      = [each.value.policy_arns]
  gitlab_url           = "https://gitlab.com"
  audience             = "https://gitlab.com"
  match_field          = each.value.match_field
  match_value          = each.value.match_value
}