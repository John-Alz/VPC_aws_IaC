resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "nequi_subnet_public" {
  count             = 3
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Nequi subnet public"
  }
}

resource "aws_subnet" "nequi_subnet_private" {
  count             = 3
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + 3)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Nequi subnet private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "nequi_rtb_public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "nequi_rtb_pubic_association" {
  count          = 3
  subnet_id      = aws_subnet.nequi_subnet_public[count.index].id
  route_table_id = aws_route_table.nequi_rtb_public.id
}


resource "aws_route_table" "nequi_rtb_private" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "nequi_rtb_private_association" {
  count          = 3
  subnet_id      = aws_subnet.nequi_subnet_private[count.index].id
  route_table_id = aws_route_table.nequi_rtb_private.id
}

resource "aws_vpc_endpoint" "nequi_vpce_s3" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.nequi_rtb_private.id]
}
