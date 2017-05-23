#!/bin/fish

#
# Run this before running terraform commands
#

function readPasswd # prompt targetVar

    echo -n $argv[1]
    stty -echo
    head -n 1 | read -g $argv[2]
    stty echo
    echo

end

echo "Please enter your username: "
head -n 1 | read -g OS_USERNAME_INPUT
export TF_VAR_user_name=$OS_USERNAME_INPUT
export OS_USERNAME=$OS_USERNAME_INPUT

echo "Please enter your tenant name: "
head -n 1 | read -g OS_TENANT_INPUT
export TF_VAR_tenant_name=$OS_TENANT_INPUT
export OS_TENANT_NAME=$OS_TENANT_INPUT

echo "Please enter your OpenStack Password: "
readPasswd ""  OS_PASSWORD_INPUT
export TF_VAR_password=$OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT

export TF_VAR_auth_url="https://ops.elastx.net:5000/v2.0"
export OS_AUTH_URL="https://ops.elastx.net:5000/v2.0"