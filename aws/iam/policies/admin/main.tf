variable "name" {}

output "policy_arn" {
  value = aws_iam_policy.policy.arn
}

resource "aws_iam_policy" "policy" {
  name        = var.name
  path        = "/"
  description = "${var.name} Policy"

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