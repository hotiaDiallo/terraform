output "vpc_id" {
  value = module.vpc.vpc_id
}

output "app_subnets" {
  value = module.vpc.app_subnets
}

output "db_subnets" {
  value = module.vpc.db_subnets
}

output "web_subnets" {
  value = module.vpc.web_subnets
}
