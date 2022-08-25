resource "aws_iam_user" "user" {
  name = var.user
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = length(var.user_policy_arns)
  user       = var.user
  policy_arn = var.user_policy_arns[count.index]

  depends_on = [
    aws_iam_user.user
  ]
}