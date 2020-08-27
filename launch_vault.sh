#!/bin/bash

/bin/sh /opt/app/onap-deployments/latest/start_vault.sh

sleep 30

oldtoken=$(awk -F ": " '/"vault-token"/ {print $2}' onap-deploy-properties.yml | tr -d ',' | tr -d '"')  
newtoken=$(awk -F ": " '/Root Token/ {print $2}' temp)
cmd1="export VAULT_ADDR=$(awk -F "=" '/VAULT_ADDR/ {print $2}' temp)"
cmd2="export VAULT_DEV_ROOT_TOKEN_ID=$newtoken"

eval $cmd1

eval $cmd2

vault secrets enable -path=aws aws

ansible-vault decrypt aws_keys.yml --vault-password-file=vault-pwd.txt

vault write aws/config/root \
     access_key=$(awk -F ": " '/aws_access_key/ {print $2}' aws_keys.yml) \
     secret_key=$(awk -F ": " '/aws_secret_key/ {print $2}' aws_keys.yml)

ansible-vault encrypt aws_keys.yml --vault-password-file=vault-pwd.txt

vault write aws/roles/my-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["iam:*", "ec2:*"],
      "Resource": "*"
    }
  ]
}
EOF

#echo "PLEASE UPDATE vault-token from $oldtoken to $newtoken IN onap-deploy-properties.yml"

sed -i "s/$oldtoken/$newtoken/g" onap-deploy-properties.yml

