#!/bin/bash

# AWS Region
AWS_REGION="us-west-1"  # Replace with your desired region

# Delete EC2 instances
echo "Deleting EC2 instances..."
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text --region $AWS_REGION)

# Wait for EC2 instances to terminate (adjust sleep duration as needed)
echo "Waiting for EC2 instances to terminate..."
sleep 30

# Delete S3 buckets
echo "Deleting S3 buckets..."
for bucket in $(aws s3api list-buckets --query 'Buckets[*].Name' --output text --region $AWS_REGION); do
  aws s3 rb s3://$bucket --force --region $AWS_REGION
done

# Delete RDS instances
echo "Deleting RDS instances..."
for db_instance_id in $(aws rds describe-db-instances --query 'DBInstances[*].DBInstanceIdentifier' --output text --region $AWS_REGION); do
  aws rds delete-db-instance --db-instance-identifier $db_instance_id --skip-final-snapshot --region $AWS_REGION
done

# Delete VPC and associated resources
echo "Deleting VPC and associated resources..."
VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text --region $AWS_REGION)
aws ec2 delete-vpc --vpc-id $VPC_ID --region $AWS_REGION

echo "Cleanup script completed."
