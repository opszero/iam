module "iam_users_with_policies" {
  for_each = var.users
  source   = "./iam_users_with_policies"

  user             = each.key
  user_policy_arns = each.value.user_policy_arns
}
