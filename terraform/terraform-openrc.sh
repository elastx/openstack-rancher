#!bin/bash
#
# Run this before running terraform commands
#
echo "Please enter your username: "
read -r OS_USERNAME_INPUT
export TF_VAR_user_name=$OS_USERNAME_INPUT
export OS_USERNAME=$OS_USERNAME_INPUT

echo "Please enter your tenant name: "
read -r OS_TENANT_INPUT
export TF_VAR_tenant_name=$OS_TENANT_INPUT
export OS_TENANT_NAME=$OS_TENANT_INPUT

echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export TF_VAR_password=$OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT

export TF_VAR_auth_url="https://ops.elastx.net:5000/v2.0"
export OS_AUTH_URL="https://ops.elastx.net:5000/v2.0"