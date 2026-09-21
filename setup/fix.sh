#!/bin/bash
export AWS_ACCESS_KEY_ID="AKIA5TBBMUAX5FM75IHR"
export AWS_SECRET_ACCESS_KEY="5JfHuCMHFuO2a9pc9c5LlR8tEf72hJzA/q/rqncC"
export AWS_DEFAULT_REGION="us-east-1" # or your Terraform region

# Remove any old session token lines if present:
unset AWS_SESSION_TOKEN

# Configure CLI automatically
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION