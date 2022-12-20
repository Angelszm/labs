# Assignment-1

# Scenario 1 - Terraform, AWS, GitLab CICD

## Setup


## AWS Cloud Design Overview
- Private S3 Bucket 
- EC2 Instance for Nginx Server
- Private Subnet
- Application Load Balancer 
- Auto Scaling Group and Lanuch Configuration




## Tasks
- [x] One Web Incremental and Decremental Counter  (website folder)
- [x] Create s3 Bucket Resource via Terraform (s3.tf)
- [x] Private S3 Bucket and S3 Configuration via Terraform  (s3.tf)
- [x] Startup Script to download contents from s3 bucket (startup_script.tpl)
- [x] Instance Profile (ec2.tf)
- [x] IAM Role and Policy for s3 (From EC2) (iam.tf)
- [x] Default VPC Resource and Subnet (ec2.tf) 
- [x] Private Subnet for Nginx Server (ec2.tf)
- [x] Security Group for Nginx Server (ec2.tf)
- [x] Instance for Nginx Server (auto-scaling-group.tf)
- [x] Security Group of Application Load Balancer (loadbalancer.tf)
- [x] Ingress (HTTP and HTTPS) and Egress (Outbound Internet Access) (loadbalancer.tf)
- [x] Restrict inbound access to both public ALB and Server Fleet A to only allow on port 80/TCP (both ec2.tf and loadbalancer)
- [x] Only allow nginx instance from public load balancer's security group with Port 80 (ec2.tf)
- [x] Application Load Balancer Resource (loadbalancer.tf)
- [x] Auto Scaling Group (auto-scaling-group.tf)
- [x] Add Gitlab CI File to deploy to s3 bucket (.gitlab.yml)
- [x] GitLab Pipeline (.gitlab.yml)
- [x] Trigger instance refresh of the autoscaling group of Server fleet A



## Additional Tasks by Angel 
- [x] Create a CloudWatch Alert which will tirgger the autoscaling policy
- [x] SNS Topic with AWS Auto Scaling Group 
- [x] Cloudwatch alarm CPU Utilization 

## Requirements for Gitlab Pipeline
- Add requirement variables for GitLab CI Pipeline (Like ASG_Instance, S3_Bucket_name)

## Improvements
- Need to use module for our terraform resources 
- Will use more variables to create same configuration with only one line 
- If I have more time and then will use more re-arrange and all in one the whole configuration. 
- S3 Bucket Configuration for more details (like encryption etc) 
