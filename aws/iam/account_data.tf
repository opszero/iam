data "aws_caller_identity" "current" {}

local "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}
