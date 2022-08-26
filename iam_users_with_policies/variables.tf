variable "user" {
  type        = string
  default     = ""
  description = "The name of IAM user"
}

variable "user_policy_arns" {
  type        = list(any)
  default     = []
  description = "List of IAM policy ARNs"

}