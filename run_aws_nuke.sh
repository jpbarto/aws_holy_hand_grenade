#!/bin/sh

echo "Configuring environment to nuke AWS account"
env

# update the configuration file for the current environment
# update the targeted account number
sed -i.bak -e 's/TARGET-AWS-ACCOUNT-NUMBER/'"$TARGET_AWS_ACCOUNT_NUMBER"'/g' aws-nuke.conf
sed -i.bak -e 's,HHG-ECS-CLUSTER,'"$HHG_ECS_CLUSTER"',g' aws-nuke.conf
sed -i.bak -e 's,HHG-LOG-GROUP,'"$HHG_LOG_GROUP"',g' aws-nuke.conf
sed -i.bak -e 's/HHG-IAM-ROLE/'"$HHG_IAM_ROLE"'/g' aws-nuke.conf

echo "aws-nuke configuration file follows..."
cat /aws-nuke.conf
echo "END OF FILE"

echo "Running aws-nuke..."
timeout -t 3600 /aws-nuke --force --no-dry-run \
    -c /aws-nuke.conf \
    --profile default

echo "aws-nuke completed normally"