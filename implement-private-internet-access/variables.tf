variable "vpc_cidr" {
  default = "10.16.0.0/16"
}

variable "name_prefix" {
  default = "devops-korner"
}

variable "web_subnet_cidrs" {
  default = ["10.16.48.0/20", "10.16.112.0/20", "10.16.176.0/20"]
}

variable "app_subnet_cidrs" {
  default = ["10.16.32.0/20", "10.16.96.0/20", "10.16.160.0/20"]
}

variable "db_subnet_cidrs" {
  default = ["10.16.16.0/20", "10.16.80.0/20", "10.16.144.0/20"]
}

variable "bastion_ami" {
  default = "ami-0453ec754f44f9a4a"
}

variable "instance_type" {
  default = "t2.micro"
}
