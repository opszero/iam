terraform {
  required_providers {
    googleworkspace = {
      source  = "hashicorp/googleworkspace"
      version = "0.7.0"
    }

    aws-sso-scim = {
      source  = "BurdaForward/aws-sso-scim"
      version = "0.7.0"
    }
  }
}

provider "aws-sso-scim" {
  endpoint = var.sso_endpoint
  token    = var.sso_token
}

provider "googleworkspace" {
  credentials = var.google_credentials
  customer_id = var.google_customer_id
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.group.member"
  ]
}