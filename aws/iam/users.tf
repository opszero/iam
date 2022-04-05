data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_user" "user" {
  for_each = var.users
  name     = each.key
}

resource "aws_iam_group_membership" "user_groups" {
  for_each   = transpose(var.users)

  name  = "${var.prefix}UserGroups"
  group = each.key
  users = each.value

  depends_on = [aws_iam_user.user]
}