#!/bin/sh

curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI -o /tmp/credentials.json
export AWS_ACCESS_KEY_ID=`jq '.AccessKeyId' /tmp/credentials.json`
export AWS_SECRET_ACCESS_KEY=`jq '.SecretAccessKey' /tmp/credentials.json`
export AWS_SECURITY_TOKEN=`jq '.Token' /tmp/credentials.json`

echo "Configuring environment to nuke AWS account"
env

# update the configuration file for the current environment
# update the targeted account number
sed -i.bak -e 's/TARGET-AWS-ACCOUNT-NUMBER/'"$AWS_ACCOUNT_ID"'/g' aws-nuke.conf

echo "aws-nuke configuration file follows..."
cat /aws-nuke.conf
echo "END OF FILE"

echo "Running aws-nuke..."
/aws-nuke --force --no-dry-run \
    -c /aws-nuke.conf \
    --access-key-id ${AWS_ACCESS_KEY_ID} \
    --secret-access-key ${AWS_SECRET_ACCESS_KEY} \
    --session-token ${AWS_SESSION_TOKEN}