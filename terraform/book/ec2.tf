data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.book_public.id
  tags = {
    Name = "web"
  }
  key_name               = "develop"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = file("./init.sh")
  provisioner "file" {
    source      = "./echoServer.js"
    destination = "/home/ubuntu/echoServer.js"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/nao_e/.ssh/develop-aws")
      host        = self.public_ip
    }
  }
  provisioner "file" {
    source      = "~/.ssh/develop-aws"
    destination = "/home/ubuntu/develop-aws"
    connection {
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/develop-aws")
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/develop-aws"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.web.public_ip
      private_key = file("~/.ssh/develop-aws")
    }
  }
}
resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.book_private.id
  tags = {
    Name = "db"
  }
  key_name               = "develop"
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  user_data              = file("./db-setup.sh")
}

# resource "aws_eip" "web" {
#  instance = aws_instance.web.id
# }