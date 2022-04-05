variable "prefix" {
  default = "MrMgr"
}

variable "groups" {
  # name = {
  #   policy_arns = []
  #   mfa = false
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