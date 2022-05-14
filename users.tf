resource "aws_iam_user" "user" {
  for_each = var.users
  name     = each.key
}

data "aws_iam_policy_document" "ssh" {
  for_each = var.users

  statement {
    actions = [
      "ec2-instance-connect:SendSSHPublicKey",
    ]

    resources = each.value.ec2_instance_connect

    condition {
      test     = "StringEquals"
      variable = "ec2:osuser"

      values = [
        "ubuntu",
      ]
    }
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
    ]

    resources = each.value.ec2_instance_connect
  }
}

resource "aws_iam_policy" "ssh" {
  for_each = data.aws_iam_policy_document.ssh
  name     = each.key
  path     = "/"
  policy   = each.value.json
}

resource "aws_iam_policy_attachment" "ssh" {
  for_each   = aws_iam_policy.ssh
  name       = each.key
  users      = [each.key]
  policy_arn = each.value.arn
}