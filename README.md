# Building a Resilient 3 tier AWS Application

## Overview
 
This project implements a highly available 3-tier architecture in AWS using Terraform across two regions (Primary and Secondary). The architecture includes:
 
Web Tier: EC2 instances running a web application.
Application Tier: EC2 instances running backend logic.
Database Tier: Amazon RDS for database storage. Stores and retrieve data.
Load Balancing: Application Load Balancer (ALB) to distribute traffic.
Failover & DNS Management: Route 53 for intelligent routing.
Networking & Security: VPC, Subnets, Security Groups, and NAT Gateway.

Each component is deployed in both Primary and Secondary regions for redundancy and failover.

## AWS Services Used and Their Purpose
 
Service	Purpose

EC2 Instances	                        Hosts Web and App tiers (2 instances per region).

Application Load Balancer (ALB)	     Balances traffic between Web and App tiers.

Amazon RDS         	                   Stores application data securely.

Route 53	                               Manages DNS-based failover between regions.

VPC & Subnets	                           Provides networking and segmentation.

Security Groups	                        Controls traffic flow and ensures security.

NAT Gateway	                             Allows private subnets to access the internet securely.

VPC Peering (Optional)	                  Enables inter-region communication if required.


 
 
---
 
## Connectivity and Data Flow

1. User Request: A user accesses the application via the internet.
2. DNS Resolution: Route 53 directs traffic to the primary region’s ALB.
3. Load Balancer: The ALB forwards requests to web instances in the primary region.
4. Application Tier: The web instances communicate with the app tier (backend instances).
5. Database Tier: The app tier interacts with Amazon RDS to fetch/store data.
6. Failover Mechanism: If the primary region fails, Route 53 automatically routes traffic to the secondary region.
7. Networking: Security groups ensure only necessary communication is allowed between the tiers.
 
Primary Region
 
1. User Access: A user enters the application domain in their browser.
2. Route 53 Routing: DNS resolution sends the request to the ALB in the Primary Region.
3. Load Balancing: The ALB forwards the request to one of the Web EC2 instances in the web tier. 
4. App Tier Processing: The web instance sends the request to the App EC2 instance (backend tier).
5. Database Query: The app instance retrieves/stores data in Amazon RDS.
6. Response to User: The processed data is returned to the web tier and displayed to the user.

Secondary Region (Failover Scenario)
 
If the Primary Region fails (e.g., ALB is down, instances crash):
 
1. Route 53 Health Check Fails: AWS detects the primary ALB is unresponsive.
2. Failover to Secondary Region: Route 53 automatically routes traffic to the Secondary ALB.
3. Application Runs in Secondary Region: The web and app instances process user requests.
4. Database Replication: The secondary RDS instance (read replica) is used until the primary region recovers.

## Deployment Steps
 
1. Clone the Repository
 
git clone https://github.com/pankajsao11/3-tier-application.git
 
2. Initialize Terraform
 
terraform init
 
3. Preview Changes
 
terraform plan
 
4. Apply Terraform Configuration
 
terraform apply -auto-approve
 
5. Get the ALB DNS Name
 
After Terraform completes, you can retrieve the ALB DNS:
 
terraform output alb_dns
 
Use this in your browser to access the deployed application.
 
6. Cleanup Resources
 
To destroy all created AWS resources, run:
 
terraform destroy -auto-approve

---
 
## Contributors
 
https://github.com/pankajsao11/3-tier-application/commits?author=pankajsao11 - Cloud DevOps Engineer
 
---
 
## License
 
This project is licensed under the https://github.com/pankajsao11/3-tier-application#Apache-2.0-1-ov-file.
