#!/bin/sh

# update the configuration file for the current environment
# update the targeted account number
sed -i .bak -e 's/TARGET-AWS-ACCOUNT-NUMBER/'"$AWS_ACCOUNT_ID"'/g' aws-nuke.conf

/aws-nuke --force --no-dry-run -c /aws-nuke.conf