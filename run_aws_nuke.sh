#!/bin/sh

# aws sts assume-role --role-arn 'arn:aws:iam::965078485732:role/hhg-task-role' --role-session-name 'local-nuke-session'

# curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI -o /tmp/credentials.json
# export AWS_ACCESS_KEY_ID=`jq '.AccessKeyId' /tmp/credentials.json`
# export AWS_SECRET_ACCESS_KEY=`jq '.SecretAccessKey' /tmp/credentials.json`
# export AWS_SECURITY_TOKEN=`jq '.Token' /tmp/credentials.json`


echo "Configuring environment to nuke AWS account"
env

# update the configuration file for the current environment
# update the targeted account number
sed -i.bak -e 's/TARGET-AWS-ACCOUNT-NUMBER/'"$AWS_ACCOUNT_ID"'/g' aws-nuke.conf
sed -i.bak -e 's,OUTPUT-LOG-GROUP,'"$CW_OUTPUT_LOG_GROUP"',g' aws-nuke.conf

echo "aws-nuke configuration file follows..."
cat /aws-nuke.conf
echo "END OF FILE"

echo "Running aws-nuke..."
/aws-nuke --force --no-dry-run \
    -c /aws-nuke.conf \
    --profile default
#     --access-key-id ${AWS_ACCESS_KEY_ID} \
#     --secret-access-key ${AWS_SECRET_ACCESS_KEY} 