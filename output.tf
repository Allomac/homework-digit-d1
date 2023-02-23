output "myserver_publicdns" {
  value = aws_instance.myserver.public_dns
}
output "mysql_db_public_dns" {
  value = aws_instance.mysql-db.public_dns
}

output "nat_gateway_ip" {
  value = aws_nat_gateway.tf-nat-1a.public_ip
}

output "dynamodb_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
