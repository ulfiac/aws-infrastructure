# aws-infrastructure

Bootstrap a new AWS account.

### Usage

1. prep
    1. create the AWS account(s)
    2. login with root user creds to the AWS Management Console
    3. enable IAM user and role access to Billing information
        - navigate to your account settings by clicking on the account name in the navigation bar (upper right)
        - select "Account"
        - locate the ""IAM User and Role Access to Billing Information" section and choose "Edit"
        - check the "Activate IAM Access" checkbox and choose "Update"
    4. install gpg
        - ```brew install gnupg```
    5. create a GPG key that will be used to encrypt the IAM user password
        - ```gpg --full-generate-key```
        - RSA and RSA, 4096 bits, no expiration, no passphrase
    6. list your GPG keys
        - ```gpg --list-secret-keys --keyid-format=long```
    7. export GPG public key (see reference links below)
        - ```gpg --export <keyid> | base64 > ./public_key_binary_base64encoded.gpg```
    8. get the sha256 hash of the file content
        - ```shasum -a 256 ./public_key_binary_base64encoded.gpg```
    9. put the sha256 hash into the "add_gpg_public_key.sh" script as the constant named ```EXPECTED_SHA256_BINARY_BASE64```
    10. add the base64 encoded GPG public key to the repo variable named ```GPG_PUBLIC_KEY_BINARY_BASE64```
2. perform an apply of the root_layer
3. perform an apply of the account_layer
4. post
    1. decrypt the IAM user password
        1. find the ```encrypted password``` output from the terraform apply
        2. set it to a shell variable
            - ```encrypted_password="<encrypted password string>"```
        3. decrypt the password
            - ```echo $encrypted_password | base64 -d | gpg --decrypt```
    2. login as the IAM user (with the decrypted password) to the AWS Management Console
    3. change the IAM user password (forced)
    4. configure MFA on the IAM user

### Notes

- Configuring MFA for the root user must be performed in the AWS Management Console.
- Configuring MFA for an IAM user must be performed in the AWS Management Console.
- Activating the "IAM user and role account to Billing information" feature is a one-time activation that must be performed by the root user of the AWS account in the AWS Management Console. It cannot be done via the AWS CLI or API.

### References

1. using gpg key with iam_user_login_profile
    - https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
    - https://stackoverflow.com/questions/53513795/pgp-key-in-terraform-for-aws-iam-user-login-profile
    - https://unix.stackexchange.com/questions/623375/what-is-the-armored-option-for-in-gnupg
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key#pgp_key
    - https://stackoverflow.com/questions/61096521/how-to-use-gpg-key-in-github-actions
    - https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file
    - https://ss64.com/mac/shasum.html
2. iam access to Billing and Cost Management
    - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html
    - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/managed-policies.html
    - https://repost.aws/knowledge-center/iam-billing-access
3. enforcing mfa
    - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage.html
4. monitoring root user activity
    - https://aws.amazon.com/blogs/security/how-to-receive-notifications-when-your-aws-accounts-root-access-keys-are-used/
    - https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/monitor-iam-root-user-activity.html
    - https://aws.amazon.com/blogs/mt/monitor-and-notify-on-aws-account-root-user-activity/
    - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail.html
