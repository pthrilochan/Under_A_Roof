#!/bin/bash

VPC_ID=vpc-098e116be10161379

# Get the Internet Gateway ID associated with the VPC
INTERNET_GATEWAY_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)

# Detach Internet Gateway if associated
if [ "$INTERNET_GATEWAY_ID" != "None" ]; then
    aws ec2 detach-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID --vpc-id $VPC_ID
fi

# Delete route tables
for rtb_id in $(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query "RouteTables[*].RouteTableId" --output text); do
    aws ec2 delete-route-table --route-table-id $rtb_id
done

# Delete the VPC
aws ec2 delete-vpc --vpc-id $VPC_ID
