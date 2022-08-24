module "iam_user_policies" {
  for_each = var.users
  source   = "./iam_user_policies"

  users            = each.key
  user_policy_arns = each.value.user_policy_arns
}
