variable "users" {
  # "opszero" = ["developers"]
}

resource "aws_iam_user" "user" {
  for_each = local.users
  name     = each.key

  tags = {
    terraform = "true"
  }
}

resource "aws_iam_group_membership" "iam-user-groups" {
  depends_on = [aws_iam_user.user]
  for_each   = transpose(var.users)

  name  = "iam-user-groups"
  group = each.key
  users = each.value
}
