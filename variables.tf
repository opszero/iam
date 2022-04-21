variable "groups" {
  default = {
    "developers" = {
      policy_arns = []    # set group policies arn from group_policies.tf here
      enable_mfa  = false
    }
  }
}

variable "users" {
  default = {
    "opszero" = {
      groups = ["developers"]
    }
  }
}

variable "github" {
  default = {
    "deployer" = {
      org         = "opszero"
      repos       = ["mrmgr"]
      policy_arns = []
    }
  }
}

variable "gitlab" {
  default = {
    "deployer" = {
      match_field = "sub"
      match_value = [
        "project_path:opszero/mrmgr:ref_type:branch:ref:main"
      ]
      policy_arns = []
    }
  }
}

variable "gitlab_oidc_url" {
  default     = "https://gitlab.com"
  type        = string
  description = "The GitLab ODIC Provider URL"

}

variable "iam_role_name" {
  default     = "gitlab_oidc_role"
  type        = string
  description = "The name of IAM Role"
}

