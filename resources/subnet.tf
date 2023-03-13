resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = var.public_subnet_cdir[0]

  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}


resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = var.private_subnet_cdir[0]

  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
  }
}