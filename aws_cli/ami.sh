#!/bin/sh
set -x

#### Describe AMI by filtering ####
AMI_NAME=project-env-amz-2-20221110T1517222
timeout=0
echo "Filter AMI by Name ..."
ami_creation_status=$(aws ec2 describe-images --profile default \
--filters "Name=name,Values=$AMI_NAME" \
--query 'Images[*].[State]' \
--region ap-southeast-1 \
--output text)
echo $ami_creation_status
while [ $timeout -lt 60 ] ; do
    if [ "available" = $ami_creation_status ]; then
        echo -ne "AMI created!!!\r"
        break
    else
        echo -ne "... ${ami_creation_status}\r"
        sleep 10
        timeout=$((timeout+10))
    fi
done
#######################################


#### Filter no tagged AMIs by creation date ####

RETENTION_DAYS=3
RETENTION_DATE=$(date --date="-$RETENTION_DAYS day" "+%Y-%m-%d")
AMI_NAME_PREFIX=project-env-amz-2*
unwanted_amis=$(aws ec2 describe-images --profile default \
    --filters "Name=name,Values=$AMI_NAME_PREFIX" \
    --query "Images[?(CreationDate<='$RETENTION_DATE' && !not_null(Tags[?Key == 'Name'].Value))].ImageId" \
    --region ap-southeast-1 \
    --output text)
for ami in $unwanted_amis; do
    echo $ami
    aws ec2 deregister-image --profile fl-admin \
        --image-id $ami \
        --region us-west-1 \
        --dry-run
done
