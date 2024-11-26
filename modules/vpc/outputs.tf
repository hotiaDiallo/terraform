output "vpc_id" {
  value = aws_vpc.main.id
}

output "app_subnets" {
  value = concat(aws_subnet.app[*].id)
}

output "db_subnets" {
  value = concat(aws_subnet.db[*].id)
}

output "web_subnets" {
  value = concat(aws_subnet.web[*].id)
}
