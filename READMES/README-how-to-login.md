# How to re-login - 
**assuming your profile is called**: dev3
0. Open new terminal to remove any residual browser sso tokens
1. `aws sso logout`
2. `export AWS_PROFILE=dev3`
3. aws sso login --profile dev3
4. login via browser: choose your username (not the group) - use password previously set in step - Create User
5. test cmd: `aws sts get-caller-identity`
