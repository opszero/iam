module "aws_oidc_gitlab" {

  for_each = var.gitlab
  source   = "git::https://github.com/thaunghtike-share/terraform-aws-oidc-gitlab.git?ref=main"


  attach_admin_policy  = false
  create_oidc_provider = true
  iam_role_name        = each.iam_role_name
  iam_policy_arns      = each.value.policy_arns
  gitlab_url           = each.gitlab_oidc_url
  audience             = each.audience
  match_field          = each.value.match_field
  match_value          = each.value.match_value
}
