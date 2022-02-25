

resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group_policy_attachment" "developers" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer.arn
}

resource "aws_iam_role_policy_attachment" "developer" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.developer.arn
}

resource "aws_iam_role" "developer" {
  name = "${var.prefix}Developer"

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

resource "aws_iam_policy" "developer" {
  name        = "${var.prefix}Developer"
  path        = "/"
  description = "${var.prefix} Developer Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PermitDeveloperAccess",
        "Effect" : "Allow",
        "NotAction" : [
          "account:*",
          "cloudtrail:*",
          "organizations:*",
          "sso:*",
          "sts:*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "PreventOutages",
        "Effect" : "Deny",
        "Action" : [
          "eks:Delete*",
          "rds:Delete*"
        ],
        "Resource" : [
          "*",
        ]
      }
    ]
  })
}



