resource "aws_iam_group" "group" {
  for_each = var.groups
  name = "Administrators"
}

resource "aws_iam_group_policy_attachment" "administrators" {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.admin.arn
}

resource "aws_iam_role_policy_attachment" "administrator" {
  role       = aws_iam_role.administrator.name
  policy_arn = aws_iam_policy.admin.arn
}

resource "aws_iam_role" "administrator" {
  name = "${var.prefix}Administrator"

  # TODO Define what can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "admin" {
  name        = "${var.prefix}Admin"
  path        = "/"
  description = "${var.prefix} Administrator Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

# # TODO Remove if not required for monitoring role/user
# resource "aws_iam_role_policy_attachment" "monitoring2fa" {
#   role       = aws_iam_role.monitoring.name
#   policy_arn = aws_iam_policy.twofa.arn
# }