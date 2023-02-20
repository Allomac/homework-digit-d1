Readme.md file for Terraform HomeWork Digit D1

Project done by me:

Please create a terraform code, with latest terraform version and syntax on AWS cloud.
 - Create a VPC
 - Create two public, and two private subnets
 - Create the necessary resources, to be able to reach internet from private subnet 
 - Create an instance on private subnet a
 - Create an instance on public subnet a
 - Be sure, these instances can communicate with each other
 - Be sure private instance is not reachable from the internet
 
-------------

Prerequisites
Before you can install the Toolkit for VS Code, you must have the following:

•	An Amazon Web Services account with needed access policies  (create a profile named terraform-user using built-in aws cli extension from VS Code)
•	A supported operating system – The Toolkit for VS Code is supported on Windows, Linux, and macOS.

•	VS Code version 1.42.0 or later – We try to keep the Toolkit for VS Code current with the default version that's available on the VS Code download page

•	The AWS command-line interface installed 
•	An AWS access key ID ( here in region eu-west-1 (Ireland))
•	Terraform v.13 (here we have exactly 1.3.9)

---------------

Here are the resources created:

•	Set aws provider for terraform
•	2 private subnets private-1a and private-1b
•	2 private subnets public-1a and public-1b


•	Internet Gateway for accessing the internet and associating it with corresponding route tables
•	2 Elastic IPs for each public subnet
•	2 NAT gateways of both public subnets with corresponding route tables
•	Private route tables to route private outbound public traffic via Nat gateways
•	1 webserver with wordpress using user date in public subnet 
•	1 database mysql server in private subnet with outbound public traffic via Nat gateway
•	S3 bucket named my-terraform-state-bucket-d1 for terraform state
•	Dynamo DB table called dynamodb-state-locking for locking the state to prevent concurrent edit





 




