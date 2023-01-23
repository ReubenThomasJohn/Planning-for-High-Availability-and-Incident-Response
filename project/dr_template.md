# Infrastructure

## AWS Zones
```aws-east-2a, aws-east-2b, aws-east-2c, aws-west1a, aws-west-1b```

## Servers and Clusters

### Table 1.1 Summary
| Asset                | Purpose                                                                               | Size        | Qty                       | DR                                |
|----------------------|---------------------------------------------------------------------------------------|-------------|---------------------------|-----------------------------------|
|                      |                                                                                       |             |                           |                                   |
| EC2 Machine          | Hosts the Ubuntu Web Server with a Flask App                                          | t3.micro    | 3x2 (one in each zone)    | 3 in us-west-1 and 3 in us-east-2 |
| EKS Cluster          | Hosts the control plane and worker nodes for the Ubuntu Web Server's monitoring stack | -           | 2 Clusters                | 1 in us-west-1 and 1 in is-east-2 |
| EKS Cluster nodes    | Worker nodes tied to cluster                                                          | t3.medium   | 2x2 (two in each cluster) | 2 in us-west-1 and 2 in us-east-2 |
| VPC                  | Private cloud network to host resources. Has IPs in multiple AZs                      | -           | 2                         | 1 in us-west-1 and 1 in us-east-2 |
| RDS Cluster          | AWS Managed SQL Database cluster                                                      | -           | 2                         | 1 in us-west-1 and 1 in us-east-2 |
| RDS Aurora Instances | Faster replication compared to RDS                                                    | db.t2.small | 4                         | 2 in us-west-1 and 2 in us-east-2 |
| Key Pairs            | Permissions to connect to instances                                                   | -           |                           |                                   |
| S3 Bucket            | Hosts terraform backend configurations                                                | -           | 2                         | 1 in us-west-1 and 1 in us-east-2 |
| ALB                  | Used to direct traffic to AWS resources                                               | -           | 2                         | 1 in us-west-1 and 1 in us-east-2 |


### Descriptions
1. EC2: 
Hosts an ubuntu operating system. A flask app is deployed on it. Prometheus exporter is installed on the machine.
2. EKS Cluster:
Used to deploy the monitoring stack which monitors the EC2 instance. Prometheus and Grafana are deployed on the worker nodes.
3. RDS Cluster:
AWS managed MySQL DB cluster. RDS Aurora DB is used to store the data.
4. S3 buckets:
Used to store terraform backends in the respective regions
5. VPC:
Virtual private cloud gives access to IPs and subnets, and is used to network our resources.
6. ALB:
Balances traffic between resources.
7. Key Pairs:
Hold the keys to access EC2 instances. 
8. ALB
Routes and directs traffic to the EC2 instances. 

## DR Plan
### Pre-Steps:
1. Take note of current architecture and available resources.
2. Use terraform to manage AWS resources (Infrastructure-as-Code)

## Steps:
### Fail-over strategy (application): 
1. Use ALB that connects to EC2 instances. This will route traffic on-the-fly without the need for manual intervention.
2. Attach a Route 53 DNS to the ALB. Route 53 has in-built monitoring, which can switch the virtual IP so traffic is routed to the EC2 instance that is healthy.

### Fail-over strategy (database): 
1. Create a seconday read-replica cluster in another region
2. In the event the primary DB fails, the secondary DB in an alernate region assumes the role of the primary. 
