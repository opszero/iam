# AWS IAM

Configures IAM users, groups, OIDC.

# Usage

## Users

Users will be created _without_ a login profile. This means the user will exist
but will not have a password to login with. Login profiles and credentials will
be managed via console manually (to prevent automated disruption of everyone).

When removing a user, first disable console access.


Users without MFA will have no privilege within the system. In order to have
access to AWS users will need to attach a MFA device to their account.

- Log in via console
- Select "My Security Credentials"
- Choose "Assign MFA device"
- Use a virtual MFA device
- Enter two consecutive MFA codes from your 2FA app
- Sign out
- Sign in with MFA


## Groups

## OIDC

OIDC Deployer allows us to access resources within another piece of
infrastructure through the use of OpenID. Check below for examples oh how dto do
deployments.

### Github

Example configuration for deploying to an EKS cluster without the need for AWS
Access Keys.

```terraform
resource "aws_iam_policy" "deployer" {
  name        = "github-deployer-policy"
  description = "Github Deployer"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}

module "iam" {
  source = "github.com/opszero/mrmgr//modules/aws"

  github = {
    "deployer" = {
      org = "opszero"
      repos = [
        "mrmgr"
      ]
      policy_arns = [
        aws_iam_policy.deployer.arn
      ]
    }
  }
}

```


kubespot

```terraform
module "opszero-eks" {
  source = "github.com/opszero/kubespot//eks"

  ...

  sso_roles = {
    admin_roles = [
      "arn:aws:iam::1234567789101:role/github-deployer"
    ]
    readonly_roles = []
    dev_roles = []
    monitoring_roles = []
  }

  ...
}

```



eksdeploy.yml

```yaml
---
on:
  push:
    branches:
      - develop
      - master

name: Deploy to Amazon EKS

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::1234567789101:role/github-deployer
          aws-region: us-east-1
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      - name: Build, tag, and push image to Amazon ECR
        id: build-image
        env:
          ECR_REGISTRY: 1234567789101.dkr.ecr.us-east-1.amazonaws.com
          ECR_REPOSITORY: mrmgr
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
      - name: Release Develop
        if: ${{ github.ref == 'refs/heads/develop' }}
        env:
          ECR_REGISTRY: 1234567789101.dkr.ecr.us-east-1.amazonaws.com
          ECR_REPOSITORY: mrmgr
          IMAGE_TAG: ${{ github.sha }}
        run: |
          aws eks update-kubeconfig --name mrmgr-develop
          helm upgrade --install mrmgr charts/mrmgr \
            -f ./charts/develop.yaml \
            --set image.repository=$ECR_REGISTRY/$ECR_REPOSITORY \
            --set image.tag=$IMAGE_TAG \

```

### Gitlab

Example configuration for deploying to AWS without the need for AWS
Access Keys. To list EKS cluster via GitLab Pipelines without using AWS credentials. You can also attach other policies to this IAM role.

```bash
resource "aws_iam_policy" "deployer" {
  name        = "gitlab-deployer-policy"
  description = "GitLab Deployer"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}

module "aws_oidc_gitlab" {

  for_each = var.gitlab
  source   = "git::https://github.com/abhiyerra/terraform-aws-oidc-gitlab.git?ref=main"


  attach_admin_policy  = false
  create_oidc_provider = true
  iam_role_name        = "gitlab_role"
  iam_policy_arns      = [aws_iam_policy.deployer.arn]
  gitlab_url           = "https://gitlab.com"
  audience             = "https://gitlab.com"
  match_field          = each.value.match_field
  match_value          = each.value.match_value
}
```
.gitlab_ci.yml

```
variables:
  REGION: us-east-1
  ROLE_ARN:  arn:aws:iam::${AWS_ACCOUNT_ID}:role/gitlab_role

image: 
  name: amazon/aws-cli:latest
  entrypoint: 
    - '/usr/bin/env'

assume role:
    script:
        - >
          STS=($(aws sts assume-role-with-web-identity
          --role-arn ${ROLE_ARN}
          --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
          --web-identity-token $CI_JOB_JWT_V2
          --duration-seconds 3600
          --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
          --output text))
        - export AWS_ACCESS_KEY_ID="${STS[0]}"
        - export AWS_SECRET_ACCESS_KEY="${STS[1]}"
        - export AWS_SESSION_TOKEN="${STS[2]}"
        - export AWS_REGION="$REGION"
        - aws sts get-caller-identity
        - aws eks list-clusters
       
```
## GitLab CI Outputs

![gitlabci_output](https://raw.githubusercontent.com/thaunghtike-share/mytfdemo/main/aws_console_outputs_photos/opszero.png)

```

