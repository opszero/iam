resource "aws_iam_user" "user" {
  for_each = var.users
  name     = each.key
}

module "iam_user_policies" {
  for_each = var.users
  source   = "./iam_user_policies"

  users            = each.key
  user_policy_arns = each.value.user_policy_arns

  depends_on = [
    aws_iam_user.user
  ]
}
