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
  # "opszero/mrmgr" = {
  #   name = "mrmgr"
  #   branch = "master"
  #   path = "mrmgr"
  # }
}