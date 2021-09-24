resource "aws_iam_group" "administrators" {
  name = "Administrators"
}

resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group" "readonly" {
  name = "ReadOnly"
}

resource "aws_iam_group" "monitoring" {
  name = "Monitoring"
}

resource "aws_iam_group_policy_attachment" "administrators" {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.opszero_admin.arn
}

resource "aws_iam_group_policy_attachment" "developers" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.opszero_developer.arn
}

resource "aws_iam_group_policy_attachment" "readonly" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.opszero_readonly.arn
}

resource "aws_iam_group_policy_attachment" "monitoring" {
  group      = aws_iam_group.monitoring.name
  policy_arn = aws_iam_policy.opszero_monitoring.arn
}

resource "aws_iam_group_policy_attachment" "administrators2fa" {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.opszero-2fa-policy.arn
}

resource "aws_iam_group_policy_attachment" "developers2fa" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.opszero-2fa-policy.arn
}

resource "aws_iam_group_policy_attachment" "readonly2fa" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.opszero-2fa-policy.arn
}

resource "aws_iam_group_policy_attachment" "monitoring2fa" {
  group      = aws_iam_group.monitoring.name
  policy_arn = aws_iam_policy.opszero-2fa-policy.arn
}
