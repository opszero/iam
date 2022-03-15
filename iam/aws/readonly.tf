resource "aws_iam_group" "readonly" {
  name = "ReadOnly"
}

resource "aws_iam_group_policy_attachment" "readonly" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.readonly.arn
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.readonly.name
  policy_arn = aws_iam_policy.readonly.arn
}

resource "aws_iam_role" "readonly" {
  name = "${var.prefix}ReadOnly"

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

# TODO I need to rethink the policy because it's too long
# LimitExceeded: Cannot exceed quota for PolicySize: 6144
resource "aws_iam_policy" "readonly" {
  name        = "${var.prefix}ReadOnly"
  path        = "/"
  description = "${var.prefix} Read Only Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:Get*",
          "ec2:List*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

