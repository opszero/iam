# TODO Remove if not required for monitoring role/user
resource "aws_iam_role_policy_attachment" "monitoring" {
  role       = aws_iam_role.monitoring.name
  policy_arn = aws_iam_policy.monitoring.arn
}

resource "aws_iam_role" "monitoring" {
  name = "${var.prefix}Monitoring"

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
resource "aws_iam_policy" "monitoring" {
  name        = "${var.prefix}Monitoring"
  path        = "/"
  description = "${var.prefix} monitoring Policy"

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







