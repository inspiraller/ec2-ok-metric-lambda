# Create account via AWS Console
1. **Sign in as root user, or administrator priviledge on the root account**
2. AWS > Organizations > Add an AWS Account
- Create an Aws Account
- AWS account name: *dev3*
- Email address: [your-email]+aws-dev3@gmail.com
- IAM role name: OrganizationAccountAccessRole
- Click - Create Account
- wait for a few minutes

3. **Refresh page to see new account**
- *dev3*
account number | [your-email]+aws-dev3@gmail.com

4. **Create Group**
- AWS > IAM Identity Center > AWS Accounts > Click - Account - dev3
- Click - Assign users or groups 
- Click Create Group: 
  - name: *group-dev*
  - Click - Create Group

5. **Assign Group *group-dev* with *AdministratorAccess* to account *dev***
- AWS > IAM Identity Center > AWS Accounts > Click - Account - dev3
- Click - Assign users or groups 
- Select - Group:*group-dev*
- Click - Next
- Select - AdministratorAccess
- Click - Submit

6. **Create User**
- AWS > IAM Identity Center > Click - Users 
  - Click - Add User
  - Username: *my-username*
  - Email: **[your email]+aws-dev3-user@gmail.com**
- Assign to group
  - Select - group-dev
  - Click - Next
  - Click - Add User
- Check email
  - Open the email you just added above:**[your email]+aws-dev3-user@gmail.com**
  - Click - Accept invitation
  - Create Password
**NOW YOU CAN USE THIS USER TO LOGIN VIA AWS CLI SSO**

7. ***Optional: Create Organizational***
 - AWS > Organizations - Select - Root > Click - Actions > Select - Create New
 - Organizational Unit name: ou-dev > Click - Create Organizational Unit

8. ***Move AWS account to Organization Unit***
  - AWS > Organizations >  Organization - Select Account > Click - Actions > Click Move 
  -  Select - Radio button - ou-dev > Click - Move AWS Account

9. Before coming out of the aws console - get the start url for your root account
- AWS > IAM Identity Center > Dashboard > Settings - AWS Access portal URL: **https://[yourid].awsapps.com/start**
- Also - copy this into .env.example
```sh
starturl="YOUR STARTER URL HERE AFTER CREATING NEW AWS ACCOUNT"
```

# Configure login to Account from aws cli terminal
1. Logout from any existing session 
```sh
aws sso logout
aws configure sso --profile dev3
```
- session name: sess-dev3
- start url: **https://[yourid].awsapps.com/start**
- region: eu-west-2
- sso registration scopes: leave blank
- [Allow permission to open browser]
- From browser window
  - From browser window - Click confirm and continue
  - Enter the name you used for your new identity center user above.
  - Enter password
  - You may need to select authenticator app
- From terminal
  - Enter default region: eu-west-2
  - Enter default output: json

# How to login
1. `export AWS_PROFILE=dev3`
2. Test user: `aws sts get-caller-identity`

# How to logout
aws sso logout

