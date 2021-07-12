# Create VPC in us-east-1
resource "aws_vpc" "vpc_main" {
  provider             = aws.region-main
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc-jenkins"
  }
}

# Create VPC in us-west-2
resource "aws_vpc" "vpc_worker" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-vpc-jenkins"
  }
}

# Create IGW in us-east-1
resource "aws_internet_gateway" "igw-main" {
  provider = aws.region-main
  vpc_id   = aws_vpc.vpc_main.id
}

# Create IGW in us-west-2
resource "aws_internet_gateway" "igw-worker" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_worker.id
}

# Get all available AZ's in VPC for main region
data "aws_availability_zones" "azs_main" {
  provider = aws.region-main
  state    = "available"
}
# Create subnet #1 in us-east-1
resource "aws_subnet" "subnet_1_main" {
  provider          = aws.region-main
  availability_zone = element(data.aws_availability_zones.azs_main.names, 0)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.0.1.0/24"
}
# Create subnet #2 in us-east-1
resource "aws_subnet" "subnet_2_main" {
  provider          = aws.region-main
  availability_zone = element(data.aws_availability_zones.azs_main.names, 1)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.0.2.0/24"
}

# Create subnet in us-west-2
resource "aws_subnet" "subnet_1_oregon" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_worker.id
  cidr_block = "192.168.1.0/24"
}
