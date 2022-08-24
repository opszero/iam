resource "aws_iam_user" "user" {
  name = var.users
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = length(var.user_policy_arns)
  user       = var.users
  policy_arn = var.user_policy_arns[count.index]

  depends_on = [
    aws_iam_user.user
  ]
}