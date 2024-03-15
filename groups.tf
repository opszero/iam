module "iam_group_with_policies" {
  for_each = var.groups

  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 5"

  name = each.key

  group_users = [
    for user, v in var.users : user
    if contains(lookup(v, "groups", []), each.key)
  ]

  attach_iam_self_management_policy = lookup(each.value, "enable_self_management", false)

  custom_group_policy_arns = concat(
    each.value.policy_arns,
    lookup(each.value, "enable_mfa", false) ? [
      aws_iam_policy.mfa.arn
  ] : [])
}