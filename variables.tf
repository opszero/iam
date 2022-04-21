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
      policy_arns = [

      ]
    }
  }
}

