variable "groups" {
  default = {}
  # name = {
  #   policy_arns = []
  #   enable_mfa = false
  # }
}

variable "users" {
  default = {}
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
