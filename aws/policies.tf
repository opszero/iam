resource "aws_iam_policy" "opszero_admin" {
  name        = "opsZeroIAM-Admin"
  path        = "/"
  description = "opsZero IAM Administrator Policy"

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

resource "aws_iam_policy" "opszero_developer" {
  name        = "opsZeroIAM-Developer"
  path        = "/"
  description = "opsZero IAM Developer Policy"

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

# TODO I need to rethink the policy because it's too long
# LimitExceeded: Cannot exceed quota for PolicySize: 6144
resource "aws_iam_policy" "opszero_readonly" {
  name        = "opsZeroIAM-ReadOnly"
  path        = "/"
  description = "opsZero IAM Read Only Policy"

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

# TODO I need to rethink the policy because it's too long
# LimitExceeded: Cannot exceed quota for PolicySize: 6144
resource "aws_iam_policy" "opszero_monitoring" {
  name        = "opsZeroIAM-Monitoring"
  path        = "/"
  description = "opsZero IAM monitoring Policy"

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

resource "aws_iam_policy" "opszero-2fa-policy" {
  name        = "opsZeroIAM-2FAPolicy"
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
        "Resource" : "arn:aws:iam::711703446389:user/$${aws:username}"
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
          "arn:aws:iam::711703446389:mfa/$${aws:username}",
          "arn:aws:iam::711703446389:user/$${aws:username}"
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
        "NotResource" : "arn:aws:iam::711703446389:user/$${aws:username}",
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
        "NotResource" : "arn:aws:iam::711703446389:user/$${aws:username}",
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
        "NotResource" : "arn:aws:iam::711703446389:user/$${aws:username}",
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
