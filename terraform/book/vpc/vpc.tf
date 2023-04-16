resource "aws_vpc" "book_vpc" {
  cidr_block = "10.0.0.0/16"
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

resource "aws_route_table" "book_rt" {
  vpc_id = aws_vpc.book_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.book_igw.id
  }
  tags = {
    Name = "book_rt"
  }
}

resource "aws_route_table_association" "book_public_association" {
  subnet_id      = aws_subnet.book_public.id
  route_table_id = aws_route_table.book_rt.id
}