variable "groups" {
  description = "Terraform object to create AWS IAM groups with custom IAM policies"
  default     = {}
  # name = {
  #   policy_arns = []
  #   enable_mfa = false
  # }
}

variable "users" {
  description = "Terraform object to create AWS IAM users"
  default     = {}
  #  "opszero" = {
  #    groups = ["developers"]
  #    ec2_instance_connect =  [
  #      "arn:aws:ec2:us-east-1:585584209241:instance/i-07e97d97102ddb52a",
  #      "arn:aws:ec2:us-east-1:585584209241:instance/i-0e3c1a0a62c51854a",
  #    ]  
  #  },
  #   "test" = {
  #    groups = ["developers"]
  #    ec2_instance_connect =  [
  #      "arn:aws:ec2:us-east-1:585584209241:instance/i-07e97d97102ddb52b",
  #      "arn:aws:ec2:us-east-1:585584209241:instance/i-0e3c1a0a62c51854b",
  #    ]  
  #  }

}

variable "github" {
  description = "Terraform object to create IAM OIDC identity provider in AWS to integrate with github actions"
  default     = {}
  # "deployer" = {
  #   org = "opszero"
  #   repos = ["mrmgr"]
  #   policy_arns = []
  # }
}

variable "gitlab" {
  description = "Terraform object to create IAM OIDC identity provider in AWS to integrate with gitlab CI"
  default     = {}
  #  "deployer" = {
  #    iam_role_name = "gitlab_oidc_role"
  #    gitlab_url    = "https://gitlab.com"
  #    audience      = "https://gitlab.com"
  #    match_field   = "sub"
  #    match_value   = [
  #      "project_path:opszero/mrmgr:ref_type:branch:ref:main"
  #    ]
  #    policy_arns   = []
  #  }
  # }
}

variable "groups_to_sync" {
  default = {}
  #  "dev@example.com" = {
  #    display_name = "Dev"
  #  },
  #  "devops@example.com" = {
  #    display_name = "DevOps"
  #  }
  #}
}

variable "permission_set_names" {
  default = {}
  #  "SSOAdmins" = {
  #    permission = "arn:aws:iam::aws:policy/AdministratorAccess"
  #  },
  #  "PowerUsers" = {
  #    permission = "arn:aws:iam::aws:policy/PowerUserAccess"
  #  }
  #}
}

variable "sso_admin_accounts" {
  default = {}
  #  "1" = {
  #    account_id         = "993450297386"
  #    group_id           = "098a25cc-d0c1-7072-593b-875c0f3c8a8a"
  #    permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-8210e6716da99c02/ps-79c6c12437d1fb53"
  #  }
  #}
}

variable "sso_endpoint" {
  type        = string
  description = "Full URL of your AWS SSO SCIM endpoint. Can also be provided via AWS_SSO_SCIM_ENDPOINT environment variable."
}

variable "sso_token" {
  type        = string
  description = "Authentication token of your AWS SSO SCIM endpoint. Can also be provided via AWS_SSO_SCIM_TOKEN environment variable."
}

variable "google_credentials" {
  description = " Either the path to or the contents of a service account key file in JSON format you can manage key files using the Cloud Console"
}

variable "google_customer_id" {
  description = "The customer id provided with your Google Workspace subscription"
}