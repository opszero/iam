variable "groups" {
  default = {}
  # name = {
  #   policy_arns = []
  #   enable_mfa = false
  # }
}

variable "users" {
  default = {}
  # "opszero" = {
  #  groups = ["developers"]
  # }
}

variable "github" {
  default = {}
  # "deployer" = {
  #   org = "opszero"
  #   repos = ["mrmgr"]
  #   policy_arns = []
  # }
}

variable "gitlab" {
  default = {}
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
