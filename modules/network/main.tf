#VPC
#Internet Gateway
#Subnets

#>VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

#>Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.name_prefix}-internet-gateway"
  }
}

#>Subnets
resource "aws_subnet" "subnet" {
  count = var.subnet_count

  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_offset, count.index+1) #(+1 so first IP doesnt have the VPC ip)
  availability_zone       = element(var.availability_zones, count.index % length(var.availability_zones))
  map_public_ip_on_launch = true # this makes it a public subnet

  tags = {
    Name = "${var.name_prefix}-subnet-${count.index + 1}"
  }
}

#>Route Table
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }


  tags = {
    Name = "${var.name_prefix}-route-table-public"
  }
}

#>Association subnets with Route Table
resource "aws_route_table_association" "subnet_association" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt-public.id
}


