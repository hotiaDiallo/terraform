resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-vpc1-igw"
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-vpc1-rt-web"
  }
}

resource "aws_route" "default_ipv4" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

/* resource "aws_subnet" "web" {
  for_each = { for i, cidr in var.web_subnet_cidrs : i => { cidr_block = cidr, az = data.aws_availability_zones.available.names[i] } }

  vpc_id                 = aws_vpc.main.id
  cidr_block             = each.value.cidr_block
  map_public_ip_on_launch = true
  availability_zone      = each.value.az

  tags = {
    Name = "${var.name_prefix}-sn-web-${each.key + 1}"
  }
}
 */

data "aws_availability_zones" "available" {}

resource "aws_subnet" "web" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.web_subnet_cidrs, count.index)
  map_public_ip_on_launch = true # This ensures that instances launched in these subnets will automatically receive public IP addresses
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.name_prefix}-sn-web-${count.index + 1}"
  }
}

resource "aws_subnet" "app" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.app_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.name_prefix}-sn-app-${count.index + 1}"
  }
}

resource "aws_subnet" "db" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.db_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.name_prefix}-sn-db-${count.index + 1}"
  }
}

