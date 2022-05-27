locals {
  ssh_users = [for user in var.users: user if length(lookup(user, "ec2_instance_connect", [])) > 0]
}

data "aws_iam_policy_document" "ssh" {
  for_each = local.ssh_users

  statement {
    actions = [
      "ec2-instance-connect:SendSSHPublicKey",
    ]

    resources = lookup(each.value, "ec2_instance_connect", [])

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

    resources = lookup(each.value, "ec2_instance_connect", [])
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
  name       = "${each.key}-ec2-instance-connect"
  users      = [each.key]
  policy_arn = each.value.arn
}
