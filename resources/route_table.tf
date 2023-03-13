# Create a route table for public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Create a route table for public subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = aws_subnet.public_subnet.cidr_block
    network_interface_id = aws_instance.bastion.primary_network_interface_id
  }

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.bastion.primary_network_interface_id
  }

  tags = {
    Name = "private_rt"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}