#!/bin/sh

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