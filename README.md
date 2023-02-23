Terraform HomeWork Digit D1

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

<!-- BEGIN_TF_DOCS -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform_locks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_eip.tfeip-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.tfeip-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.myserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.mysql-db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.my-vpc-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.tf-nat-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.tf-nat-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.internet-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.my-vpc-rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.tf-private-route-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.tf-private-route-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.http-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.mysql-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-1a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public-1b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.my-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | The port the server will use for HTTP requests | `number` | n/a | yes |
| <a name="input_ami"></a> [ami](#input\_ami) | Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | my aws region | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | my s3 bucket name | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | n/a | `string` | n/a | yes |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | n/a | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_myserver_publicdns"></a> [myserver\_publicdns](#output\_myserver\_publicdns) | n/a |
| <a name="output_mysql_db_public_dns"></a> [mysql\_db\_public\_dns](#output\_mysql\_db\_public\_dns) | n/a |
| <a name="output_nat_gateway_ip"></a> [nat\_gateway\_ip](#output\_nat\_gateway\_ip) | n/a |

---

Copyright © 2023, Marc
<!-- END_TF_DOCS -->