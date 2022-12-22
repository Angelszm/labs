# Assignment-1

# Scenario 1 - Terraform, AWS, GitLab CICD


## AWS Cloud Design Overview
- Private S3 Bucket 
- EC2 Instance for Nginx Server
- Private Subnet
- Application Load Balancer 
- Auto Scaling Group and Lanuch Configuration




## Tasks
- [x] One Web Incremental and Decremental Counter  (website folder [https://github.com/Angelszm/labs/tree/main/assignment/website])
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
- [x] Need to add more readable outputs in outputs file. 

## Requirements for Gitlab Pipeline
- Add requirement variables for GitLab CI Pipeline (Like ASG_Instance, S3_Bucket_name, ECR_REPO_URL etc)

## Improvements
- Need to use module for our terraform resources 
- Will use more variables to create same configuration with only one line 
- If I have more time and then will use more re-arrange and all in one the whole configuration. 
- S3 Bucket Configuration for more details (like encryption etc) 



# Assignment-2

# Scenario 2: Kubernetes 

## Tasks
- [x] minikube and docker on local machine (Local install)
- [x] Will use Default Namespace for our app and MySQL Server
- [x] Environment Var Name for Docker Container (ecr.tf with var.env)
- [x] Incremental and Decremental Counter Dockerfile and Docker Build (ecr_build stage on gitlab file)
- [x] Docker Build on gitlab pipeline (gitlab ci file)
- [x] Deploy MySQL Server on k8s (mysql-server.yaml)
- [x] Create a table in a MySQL Database (with k8s ConfigMap)
- [x] Implement Counter App on local minikube with horizontal auto scaling
- [x] Counter app able to communicate with MySQL Server (Cluster IP, Use this mysql.default.svc.cluster.local)
- [x] Deploy Prometheus and Grafana (assignment2.sh)
- [x] Access Dashbaord on Minikube (assignment2.sh)
- [x] Grafana Dashboard Username & Password  (assignment2.sh)
- [x] Added promql metrics for alerts (Please kindly review below)


## Additonal 
- If we wanted to add personal alerts and then 
```
- Basically need to create the rules on a configmap (Add under data section)
- Load the promethues pod with the configmap
- Inject the prometheus config to read the file from the configmap
```

## Prometheus 
Two Options here for this: 
https://github.com/prometheus-community/helm-charts or prometheus-community/kube-prometheus-stack



## For Prometheus Monitoring 
## Prometheus Datasource 
- Check Data Source Page on Grafana Dashboard 

## Production Metrics
- https://medium.com/@jeff.lee.1990710/how-to-install-prometheus-grafana-stack-to-monitor-your-kubernetes-clusters-9d1bf2496803

## Title: Memory Usage with bytes
```
sum(container_memory_usage_bytes{namespace="default"}) by (namespace,pod)
```
Description:  Memory Usage with bytes


## Title: Memory Usage with GB
```
sum(container_memory_working_set_bytes{namespace="default",image!="", container!="POD"}) by (container,namespace) /1000 / 1000
```
Description:  Memory Usage with GB


## Title: Per-container memory usage in bytes
```
sum(container_memory_usage_bytes{container!~"POD|"}) by (namespace,pod,container)
```

## Title: Per-container CPU usage in CPU Cores
```
sum(rate(container_cpu_usage_seconds_total{container!~"POD|"}[5m])) by (namespace,pod,container)
```

## Title: Unhealthy Production Pods 
```
min_over_time(sum by (namespace, pod) (kube_pod_status_phase{phase=~"Pending|Unknown|Failed"})) > 0
```
Description: Number of Unhealthy Production Pods



## Number of Containers Without CPU Limits In Each Namespace
 ```
 count by (namespace)(sum by (namespace,pod,container)(kube_pod_container_info{container!=""}) unless sum by (namespace,pod,container)(kube_pod_container_resource_limits{resource="cpu"}))
 ```
 Description: Number of Containers Without CPU Limits In Each Namespace:


## Monitoring Persistent Volume Claim Free Space (50 % Free Space)
 ```
  100 * (kubelet_volume_stats_available_bytes / kubelet_volume_stats_capacity_bytes)
 ```
 Description: Checking % of Free Space  with our persistent Volume Claim 


## Monitoring Horizontal Auto Scaling 
 ```
 kube_deployment_status_replicas
 ```
 Description: Number of Replicas based on Horizontal Auto Scaling


 ## Deployment at 0 Replicas State alert
 ```
   sum(kube_deployment_status_replicas{pod_template_hash=""}) by (deployment,namespace)  < 1
 ```
 Description: Deployment at 0 Replicas State Alert


# HTTP Status Codes 
# TYPE http_server_requests_seconds summary
```
http_server_requests_seconds{app="angel-counter-app",client="client1",exception="None",method="GET",status="200",uri="/index.html",quantile="0.95",} 0.771751936
sum(rate(http_server_requests_seconds_count{app="test-app"}[1m]))
sum (rate(http_server_requests_seconds_count{app="test-app", status=~"5.."}[1m]))
```

```
Ref : https://sysdig.com/blog/prometheus-query-examples/
Ref : https://sysdig.com/blog/kubernetes-resource-limits/
Ref: https://www.sudlice.org/openshift/monitoring/prometheus_promql_queries/
Ref: https://sysdig.com/blog/monitor-nginx-kubernetes/
Ref: https://www.containiq.com/post/promql-cheat-sheet-with-examples
Ref: https://medium.com/expedia-group-tech/creating-monitoring-dashboards-1f3fbe0ae1ac
Ref : https://medium.com/backstagewitharchitects/how-to-setup-monitoring-using-prometheus-and-grafana-9ba7bf8cbda9 


## Useful Morden Dashboards

Ref: https://medium.com/@dotdc/a-set-of-modern-grafana-dashboards-for-kubernetes-4b989c72a4b2
```