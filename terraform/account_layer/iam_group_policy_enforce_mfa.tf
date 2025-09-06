data "aws_iam_policy_document" "enforce_mfa" {

  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage.html

  # the AllowViewAccountInfo statement allows the user to view account-level information
  statement {
    sid    = "AllowViewAccountInfo"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy", # view the account password requirements while changing their own IAM user password
      "iam:ListVirtualMFADevices",    # view details about a virtual MFA device that is enabled for the user
      "iam:ListUsers",                # added to allow users to view the Users page in the IAM console and use that page to access their own user information
    ]
    resources = ["*"] # these permissions must be in their own statement because they do not support or do not need to specify a resource ARN
  }

  # the AllowManageOwnPasswords statement allows the user to change their own password
  statement {
    sid    = "AllowManageOwnPasswords"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:GetLoginProfile",    # added to allow users to change their password on their own user page
      "iam:GetUser",            # required to view most of the information on the My security credentials page
      "iam:UpdateLoginProfile", # added to allow users to change their password on their own user page
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"] # $$ needed so the $ is not interpreted by terraform
  }

  # the AllowManageOwnAccessKeys statement allows the user to create, update, and delete their own access keys
  # the user can also retrieve information about when the specified access key was last used
  statement {
    sid    = "AllowManageOwnAccessKeys"
    effect = "Allow"
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
      "iam:GetAccessKeyLastUsed",
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"] # $$ needed so the $ is not interpreted by terraform
  }

  # the AllowManageOwnSigningCertificates statement allows the user to upload, update, and delete their own signing certificates
  statement {
    sid    = "AllowManageOwnSigningCertificates"
    effect = "Allow"
    actions = [
      "iam:DeleteSigningCertificate",
      "iam:ListSigningCertificates",
      "iam:UpdateSigningCertificate",
      "iam:UploadSigningCertificate"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  # the AllowManageOwnSSHPublicKeys statement allows the user to upload, update, and delete their own SSH public keys for CodeCommit
  statement {
    sid    = "AllowManageOwnSSHPublicKeys"
    effect = "Allow"
    actions = [
      "iam:DeleteSSHPublicKey",
      "iam:GetSSHPublicKey",
      "iam:ListSSHPublicKeys",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  # the AllowManageOwnGitCredentials statement allows the user to create, update, and delete their own Git credentials for CodeCommit
  statement {
    sid    = "AllowManageOwnGitCredentials"
    effect = "Allow"
    actions = [
      "iam:CreateServiceSpecificCredential",
      "iam:DeleteServiceSpecificCredential",
      "iam:ListServiceSpecificCredentials",
      "iam:ResetServiceSpecificCredential",
      "iam:UpdateServiceSpecificCredential"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  # the AllowManageOwnVirtualMFADevice statement allows the user to create their own virtual MFA device
  # the resource ARN in this statement allows the user to create an MFA device with any name,
  #   but the other statements in the policy only allow the user to attach the device to the currently signed-in user
  statement {
    sid    = "AllowManageOwnVirtualMFADevice"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice"
    ]
    resources = ["arn:aws:iam::*:mfa/*"]
  }

  # the AllowManageOwnUserMFA statement allows the user to view or manage the virtual, U2F, or hardware MFA device for their own user
  # the resource ARN in this statement allows access to only the user's own IAM user
  # users can't view or manage the MFA device for other users.
  statement {
    sid    = "AllowManageOwnUserMFA"
    effect = "Allow"
    actions = [
      "iam:DeactivateMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  # the DenyAllExceptListedIfNoMFA statement denies access to every action in all AWS services,
  #   except a few listed actions, but only if the user is not signed in with MFA
  # the statement uses a combination of "Deny" and "NotAction" to explicitly deny access to every action that is not listed
  # the items listed are not denied or allowed by this statement
  # however, the actions are allowed by other statements in the policy
  # for more information about the logic for this statement, see NotAction with Deny
  # if the user is signed in with MFA, then the Condition test fails and this statement does not deny any actions
  # in this case, other policies or statements for the user determine the user's permissions

  # this statement ensures that when the user is not signed in with MFA that they can perform only the listed actions
  # in addition, they can perform the listed actions only if another statement or policy allows access to those actions
  # this does not allow a user to create a password at sign-in, because iam:ChangePassword action should not be allowed without MFA authorization

  # the ...IfExists version of the Bool operator ensures that if the aws:MultiFactorAuthPresent key is missing, the condition returns true
  # this means that a user accessing an API with long-term credentials, such as an access key, is denied access to the non-IAM API operations
  statement {
    sid    = "DenyAllExceptListedIfNoMFA"
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:GetMFADevice",
      "iam:ListMFADevices",
      "iam:ListUsers", # added to allow users to view the Users page in the IAM console and use that page to access their own user information
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "sts:GetSessionToken"
    ]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_group_policy" "enforce_mfa" {
  group  = aws_iam_group.default_group.name
  name   = local.iam_group_policy_name_enforce_mfa
  policy = data.aws_iam_policy_document.enforce_mfa.json
}
