module "bitbucket" {
  for_each = var.bitbucket

  module "bitbucket-oidc" {
    source  = "helecloud/bitbucket-oidc/aws"
    version = "0.0.1"
  }

  workspace_name = each.value.workspace_name
  workspace_uuid = each.value.workspace_uuid

  roles = {
    role1 = {
      name             = "bitbucket-${each.key}"
      allowed_subjects = ["{xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxxx}*"]
      # This is matched against the sub claim, which provided in the following format:
      # {REPOSITORY_UUID}[:{ENVIRONMENT_UUID}]:{STEP_UUID}
      # More info here: https://support.atlassian.com/bitbucket-cloud/docs/deploy-on-aws-using-bitbucket-pipelines-openid-connect/#Using-claims-in-ID-tokens-to-limit-access-to-the-IAM-role-in-AWS

      inline_policies_json = [data.aws_iam_policy_document.pipeline_role.json]
      # You can either add policies inline here or add them via aws_iam_role_policy_attachment resource
    }
  }
}
