data "aws_caller_identity" "current" {}

# Enable GuardDuty

resource "aws_organizations_organization" "sec-tooling" {
  aws_service_access_principals = ["guardduty.amazonaws.com", "securityhub.amazonaws.com"]
  feature_set                   = "ALL"
}

resource "aws_guardduty_detector" "sec-tooling" {}

resource "aws_guardduty_organization_admin_account" "sec-tooling" {
  depends_on = [aws_organizations_organization.sec-tooling]
  admin_account_id = data.aws_caller_identity.current.account_id
}

#  Enable Macie

resource "aws_macie2_account" "sec-tooling" {}

resource "aws_macie2_organization_admin_account" "sec-tooling" {
  admin_account_id = data.aws_caller_identity.current.account_id
  depends_on       = [aws_macie2_account.sec-tooling]
}

# Enable SecurityHub

resource "aws_securityhub_account" "sec-tooling" {}

resource "aws_securityhub_organization_admin_account" "sec-tooling" {
  depends_on = [aws_organizations_organization.sec-tooling]
  admin_account_id = data.aws_caller_identity.current.account_id
}

# Auto enable security hub in organization member accounts

resource "aws_securityhub_organization_configuration" "sec-tooling" {
  auto_enable = true
}

# Create S3 Bucket

resource "aws_s3_bucket" "sandbox_bucket" {
  bucket = "aft-sandbox-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}
