resource "aws_vpc" "book_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "book_vpc"
  }
}

resource "aws_subnet" "book_public" {
  vpc_id     = aws_vpc.book_vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "book-public-0"
  }
}

resource "aws_subnet" "book_private" {
  vpc_id     = aws_vpc.book_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "book-private-1"
  }
}

resource "aws_internet_gateway" "book_igw" {
  vpc_id = aws_vpc.book_vpc.id
  tags = {
    Name = "book-igw"
  }
}

resource "aws_route_table" "book_rtb" {
  vpc_id = aws_vpc.book_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.book_igw.id
  }
  tags = {
    Name = "book_rtb"
  }
}

resource "aws_route_table_association" "book_public_association" {
  subnet_id      = aws_subnet.book_public.id
  route_table_id = aws_route_table.book_rtb.id
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.book_public.id
  allocation_id = aws_eip.nat.id
  tags = {
    Name = "NAT"
  }
  depends_on = [aws_internet_gateway.book_igw]
}

resource "aws_eip" "nat" {

}

resource "aws_route_table" "nat_rtb" {
  vpc_id = aws_vpc.book_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "nat_rtb"
  }
}

resource "aws_route_table_association" "nat_association" {
  subnet_id      = aws_subnet.book_private.id
  route_table_id = aws_route_table.nat_rtb.id
}