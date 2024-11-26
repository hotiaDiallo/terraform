variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for the web subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for the app subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for the database subnets"
  type        = list(string)
}
