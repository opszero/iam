data "googleworkspace_users" "all_users" {}

resource "aws-sso-scim_user" "user" {
  for_each = {
    for user in data.googleworkspace_users.all_users.users : user.primary_email => {
      display_name = one(user.name).full_name
      family_name  = one(user.name).family_name
      given_name   = one(user.name).given_name
      suspended    = user.suspended
    }
  }
  display_name = each.value.display_name
  family_name  = each.value.family_name
  given_name   = each.value.given_name
  user_name    = each.key
  active       = !each.value.suspended
}

data "googleworkspace_group" "group" {
  for_each = var.groups_to_sync
  email    = each.key
}

resource "aws-sso-scim_group" "group" {
  for_each     = var.groups_to_sync
  display_name = each.value.display_name
}

data "googleworkspace_group_members" "group_members" {
  for_each = var.groups_to_sync
  group_id = data.googleworkspace_group.group[each.key].id
}

resource "aws-sso-scim_group_member" "group_member" {
  for_each = {
    for group_member in flatten([
      for group in data.googleworkspace_group.group : [
        for member in data.googleworkspace_group_members.group_members[group.email].members : {
          user_id     = member.email
          group_email = group.email
        }
      ]
    ]) : "${group_member.group_email}/${group_member.user_id}" => group_member
  }
  group_id = aws-sso-scim_group.group[each.value.group_email].id
  user_id  = aws-sso-scim_user.user[each.value.user_id].id
}

data "aws_ssoadmin_instances" "sso" {}

locals {
  sso_instance_arn = one(data.aws_ssoadmin_instances.sso.arns)
}

resource "aws_ssoadmin_permission_set" "permission_set" {
  for_each     = var.permission_set_names
  name         = each.key
  instance_arn = local.sso_instance_arn
}

resource "aws_ssoadmin_managed_policy_attachment" "attachment" {
  for_each           = var.permission_set_names
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.key].arn
  managed_policy_arn = each.value.permission

  depends_on = [
    aws_ssoadmin_permission_set.permission_set
  ]
}

resource "aws_ssoadmin_account_assignment" "global_assignments" {
  for_each = var.sso_admin_accounts

  principal_id       = each.value.group_id
  permission_set_arn = each.value.permission_set_arn
  instance_arn       = local.sso_instance_arn
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
  principal_type     = "GROUP"

  depends_on = [
    aws-sso-scim_group.group,
    aws-sso-scim_group_member.group_member
  ]
}