# IAM

Configures IAM users, groups, roles, and policies.

## Users
Users should be created and assigned groups via `variables.tf` each user is specified as a mapping of `user = [group1, group2]`. Each group must exist in order for user creation to occur successfully.

### Onboarding Users

Users without MFA will have no privilege within the system. In order to have access to AWS users will need to attach a MFA device to their account.

- Log in via console
- Select "My Security Credentials"
- Choose "Assign MFA device"
- Use a virtual MFA device
- Enter two consecutive MFA codes from your 2FA app
- Sign out
- Sign in with MFA

### Special user note!

Users will be created _without_ a login profile. This means the user will exist but will not have a password to login with. Login profiles and credentials will be managed via console manually (to prevent automated disruption of everyone).

When removing a user, first disable console access.

## Groups
Groups should be specified in `groups.tf` each it's own resource.

## Roles
Roles need an assume_role_policy so the role can attach to a service or entity

## Policies
Policies were created for each function (admin, readonly, developer, monitoring) but this will need to be tuned and attached to a group or role as desired.