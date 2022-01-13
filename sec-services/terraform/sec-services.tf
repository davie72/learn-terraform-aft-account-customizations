org-acc = var.ct_management_account_id
data "aws_caller_identity" "current" {}

# Enable GuardDuty

resource "aws_guardduty_detector" "sec-tooling2" {}

resource "aws_guardduty_organization_admin_account" "sec-tooling2" {
  depends_on = [aws_organizations_organization.org-acc]
  admin_account_id = data.aws_caller_identity.current.account_id
}

#  Enable Macie

resource "aws_macie2_account" "member-acc" {}

resource "aws_macie2_organization_admin_account" "sec-tooling2" {
  admin_account_id = data.aws_caller_identity.current.account_id
  depends_on       = [aws_macie2_account.member-acc]
}

# Enable SecurityHub

resource "aws_securityhub_organization_admin_account" "sec-tooling2" {
  depends_on = [aws_organizations_organization.org-acc]
  admin_account_id = data.aws_caller_identity.current.account_id
}

# Auto enable security hub in organization member accounts

resource "aws_securityhub_organization_configuration" "sec-tooling2" {
  auto_enable = true
}

# Create S3 Bucket

resource "aws_s3_bucket" "sandbox_bucket" {
  bucket = "aft-sandbox-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}
