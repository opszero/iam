data "aws_iam_policy_document" "vanta_child" {
  statement {
    actions = [
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
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "datapipeline:EvaluateExpression",
      "datapipeline:QueryObjects",
      "rds:DownloadDBLogFilePortion"
    ]
    resources = ["*"]
    effect    = "Deny"
  }
}

resource "aws_iam_policy" "vanta_child" {
  count       = var.vanta_enabled && !var.management_account ? 1 : 0
  name        = "VantaAdditionalPermissions"
  description = "Policy to allow specified actions and deny specified actions in the child account"
  policy      = data.aws_iam_policy_document.vanta_child.json
}

resource "aws_iam_role_policy_attachment" "vanta_child" {
  count      = var.vanta_enabled && !var.management_account ? 1 : 0
  role       = aws_iam_role.vanta_auditor[0].name
  policy_arn = aws_iam_policy.vanta_child[0].arn
}

data "aws_iam_policy_document" "vanta_management" {
  statement {
    actions = [
      "datapipeline:EvaluateExpression",
      "datapipeline:QueryObjects",
      "rds:DownloadDBLogFilePortion"
    ]
    resources = ["*"]
    effect    = "Deny"
  }
}

resource "aws_iam_policy" "vanta_management" {
  count       = var.vanta_enabled && var.management_account ? 1 : 0
  name        = "VantaManagementAccountPermissions"
  description = "Policy to deny specified actions in the management account"
  policy      = data.aws_iam_policy_document.vanta_management.json
}

resource "aws_iam_role_policy_attachment" "vanta_management" {
  count      = var.vanta_enabled && var.management_account ? 1 : 0
  role       = aws_iam_role.vanta_auditor[0].name
  policy_arn = aws_iam_policy.vanta_management[0].arn
}

data "aws_iam_policy" "SecurityAudit" {
  arn = "arn:${local.partition}:iam::aws:policy/SecurityAudit"
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
