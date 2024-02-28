resource "aws_iam_role_policy" "vanta_child" {
  count = var.vanta_enabled && !var.management_account ? 1 : 0

  name = "VantaAdditionalPermissions"
  role = aws_iam_role.vanta_auditor[0].id

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

resource "aws_iam_role_policy" "vanta_management" {
  count = var.vanta_enabled && var.management_account ? 1 : 0

  name = "VantaManagementAccountPermissions"
  role = aws_iam_role.vanta_auditor[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
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

data "aws_iam_policy" "SecurityAudit" {
  arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "vanta_security_audit" {
  role       = aws_iam_role.vanta_auditor[0].id
  policy_arn = data.aws_iam_policy.SecurityAudit.arn
}

resource "aws_iam_role" "vanta_auditor" {
  count = var.vanta_enabled ? 1 : 0

  name = "vanta-auditor"

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
