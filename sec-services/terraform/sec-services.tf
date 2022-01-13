variable "org-acc" {
  type = string
  default =  var.ct_management_account_id
}

data "aws_caller_identity" "current" {}

# Enable GuardDuty

resource "aws_guardduty_detector" "sec-tooling2" {}

resource "aws_guardduty_organization_admin_account" "sec-tooling2" {
  depends_on = [aws_organizations_organization.org-acc]
  admin_account_id = data.aws_caller_identity.current.account_id
}