variable "prefix" {
  default = "MrMgr"
}

variable "groups" {
  default = {}
  # name = {
  #   policy_arns = []
  #   enable_mfa = false
  # }
}

variable "users" {
  # "opszero" = {
  #  groups = ["developers"]
  # }
}

variable "github" {
  default = {}
  # "opszero/mrmgr" = {
  #   name = "mrmgr"
  #   branch = "master"
  #   path = "mrmgr"
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