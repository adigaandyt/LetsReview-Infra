#VPC
#Internet Gateway
#Subnets

#>VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "andy-vpc"
  }
}

#>Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "andy-internet-gateway"
  }
}

# #>Subnet 1 priv
# resource "aws_subnet" "mysubnet1" {
#   vpc_id            = aws_vpc.myvpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "${var.aws_region}a"

#   tags = {
#     Name                                 = "andy-subnet-private-1"
#     "kubernetes.io/role/internal-elb"    = "1"     # Tag for load balancer on private subnet
#     "kubernetes.io/cluster/andy-cluster" = "owned" # might need to be shared to access mongodb
#   }
# }

# #>Subnet 2 priv
# resource "aws_subnet" "mysubnet2" {
#   vpc_id            = aws_vpc.myvpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "${var.aws_region}b"

#   tags = {
#     Name                                 = "andy-subnet-private-2"
#     "kubernetes.io/role/internal-elb"    = "1"     # Tag for load balancer on private subnet
#     "kubernetes.io/cluster/andy-cluster" = "owned" # might need to be shared to access mongodb
#   }
# }

#>Subnet 3 pub
resource "aws_subnet" "mysubnet3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true # for a public k8r instance group

  tags = {
    Name                                 = "andy-subnet-public-1"
    "kubernetes.io/role/internal-elb"    = "1"     # Tag for load balancer on private subnet
    "kubernetes.io/cluster/andy-cluster" = "owned" # might need to be shared to access mongodb
  }
}

#>Subnet 4 pub
resource "aws_subnet" "mysubnet4" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true # for a public k8r instance group

  tags = {
    Name                                 = "andy-subnet-public-2"
    "kubernetes.io/role/internal-elb"    = "1"     # Tag for load balancer on private subnet
    "kubernetes.io/cluster/andy-cluster" = "owned" # might need to be shared to access mongodb
  }
}

# #>NAT Gateway
# resource "aws_eip" "nat" {

#   domain = "vpc"

#   tags = {
#     Name = "andy-NAT"
#   }
# }

# resource "aws_nat_gateway" "natgate" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.mysubnet3.id

#   tags = {
#     Name = "andy-nat"
#   }

#   depends_on = [aws_internet_gateway.my_igw]
# }

#>Route Table

# resource "aws_route_table" "rt-private" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.natgate.id
#   }

#   tags = {
#     Name = "andy-route-table-private"
#   }
# }

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }


  tags = {
    Name = "andy-route-table-public"
  }
}

#>Association subnets with route tables
# resource "aws_route_table_association" "subnet_association_subnet1" {
#   subnet_id      = aws_subnet.mysubnet1.id
#   route_table_id = aws_route_table.rt-private.id
# }
# resource "aws_route_table_association" "subnet_association_subnet2" {
#   subnet_id      = aws_subnet.mysubnet2.id
#   route_table_id = aws_route_table.rt-private.id
# }
resource "aws_route_table_association" "subnet_association_subnet3" {
  subnet_id      = aws_subnet.mysubnet3.id
  route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "subnet_association_subnet4" {
  subnet_id      = aws_subnet.mysubnet4.id
  route_table_id = aws_route_table.rt-public.id
}

