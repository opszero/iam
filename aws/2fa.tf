
resource "aws_iam_group_policy_attachment" "administrators2fa" {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_group_policy_attachment" "developers2fa" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_group_policy_attachment" "readonly2fa" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_group_policy_attachment" "monitoring2fa" {
  group      = aws_iam_group.monitoring.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_role_policy_attachment" "administrator2fa" {
  role       = aws_iam_role.administrator.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_role_policy_attachment" "developer2fa" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_role_policy_attachment" "readonly2fa" {
  role       = aws_iam_role.readonly.name
  policy_arn = aws_iam_policy.twofa.arn
}

# TODO Remove if not required for monitoring role/user
resource "aws_iam_role_policy_attachment" "monitoring2fa" {
  role       = aws_iam_role.monitoring.name
  policy_arn = aws_iam_policy.twofa.arn
}

resource "aws_iam_policy" "twofa" {
  name        = "${var.prefix}2FAPolicy"
  path        = "/"
  description = "Policy ensures users are utilizing 2fa"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PermitSelfPasswordChange",
        "Effect" : "Allow",
        "Action" : [
          "iam:ChangePassword",
          "iam:GetLoginProfile"
        ],
        "Resource" : "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}"
      },
      {
        "Sid" : "SelfServiceMFA",
        "Effect" : "Allow",
        "Action" : [
          "iam:*List*",
          "iam:CreateAccessKey",
          "iam:CreateVirtualMFADevice",
          "iam:DeactivateMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ResyncMFADevice"
        ],
        "Resource" : [
          "arn:aws:iam::${var.aws_account_id}:mfa/$${aws:username}",
          "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}"
        ]
      },
      {
        "Sid" : "PermitGetListMFA",
        "Effect" : "Allow",
        "Action" : [
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListMFADevices",
          "iam:ListRoles",
          "iam:ListUsers",
          "iam:ListVirtualMFADevices"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "PermitGetAccountPasswordPolicy",
        "Effect" : "Allow",
        "Action" : "iam:GetAccountPasswordPolicy",
        "Resource" : "*"
      },
      {
        "Effect" : "Deny",
        "NotAction" : [
          "iam:ChangePassword",
          "iam:CreateAccessKey",
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:GetLoginProfile",
          "iam:List*"
        ],
        "NotResource" : "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}",
        "Condition" : {
          "Null" : {
            "aws:MultiFactorAuthAge" : "true"
          }
        }
      },
      {
        "Effect" : "Deny",
        "NotAction" : [
          "iam:ChangePassword",
          "iam:CreateAccessKey",
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:GetAccountPasswordPolicy",
          "iam:GetLoginProfile",
          "iam:List*"
        ],
        "NotResource" : "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}",
        "Condition" : {
          "NumericGreaterThan" : {
            "aws:MultiFactorAuthAge" : "86400"
          }
        }
      },
      {
        "Effect" : "Deny",
        "NotAction" : [
          "iam:ChangePassword",
          "iam:CreateAccessKey",
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:GetAccountPasswordPolicy",
          "iam:GetLoginProfile",
          "iam:List*"
        ],
        "NotResource" : "arn:aws:iam::${var.aws_account_id}:user/$${aws:username}",
        "Condition" : {
          "NumericGreaterThan" : {
            "aws:MultiFactorAuthAge" : "86400"
          }
        }
      },
      {
        "Effect" : "Deny",
        "NotAction" : [
          "iam:ChangePassword",
          "iam:CreateAccessKey",
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetAccountPasswordPolicy",
          "iam:GetUser",
          "iam:List*"
        ],
        "Resource" : "*",
        "Condition" : {
          "Null" : {
            "aws:MultiFactorAuthAge" : "true"
          }
        }
      },
      {
        "Effect" : "Deny",
        "NotAction" : [
          "iam:ChangePassword",
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetAccountPasswordPolicy",
          "iam:GetUser",
          "iam:List*"
        ],
        "Resource" : "*",
        "Condition" : {
          "NumericGreaterThan" : {
            "aws:MultiFactorAuthAge" : "86400"
          }
        }
      }
    ]
  })
}