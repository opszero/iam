resource "aws_iam_role_policy" "vanta" {
  count = var.vanta_enabled ? 1 : 0

  name = "VantaAdditionalPermissions"
  role = aws_iam_role.vanta-auditor.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "identitystore:DescribeGroup",
        "identitystore:DescribeGroupMembership",
        "identitystore:DescribeUser",
        "identitystore:GetGroupId",
        "identitystore:GetGroupMembershipId",
        "identitystore:GetUserId",
        "identitystore:IsMemberInGroups",
        "identitystore:ListGroupMemberships",
        "identitystore:ListGroups",
        "identitystore:ListUsers",
        "identitystore:ListGroupMembershipsForMember"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "datapipeline:EvaluateExpression",
        "datapipeline:QueryObjects",
        "rds:DownloadDBLogFilePortion"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_role" "vanta-auditor" {
  count = var.vanta_enabled ? 1 : 0

  name = "vanta-auditor"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/SecurityAudit",
  ]

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "AWS" : var.vanta_account_id
          },
          "Condition" : {
            "StringEquals" : {
              "sts:ExternalId" : var.vanta_external_id
            }
          }
        }
      ]
  })
}
