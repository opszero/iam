variable "groups" {
  default = {
    "developers" = {
      policy_arns = []
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
      org         = "thaunghtike-share"
      repos       = ["mytfdemo", "terraform-aws-mrmgr"]
      policy_arns = []
    }
  }
}

variable "gitlab" {
  default = {
    "deployer" = {
      match_field = "sub"
      match_value = [
        "project_path:thaunghtikeoo/demo:ref_type:branch:ref:main",
        "project_path:thaunghtikeoo/oidc-demo:ref_type:branch:ref:main"
      ]
      policy_arns = [

      ]
    }
  }
}

