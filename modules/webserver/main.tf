resource "aws_security_group" "mywebsecurity" {
  name        = "ownsecurityrules"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
 
   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
     }
 
  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["49.205.238.14/32"]
     }
 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  tags = {
    Name = "${var.env}-sg"
  }
}


data "aws_ami" "myami" {
  most_recent = true
   filter{
     name="name"
     values=["amzn2-ami-kernel-*-x86_64-gp2"]
   }
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
  owners = ["amazon"]
}

resource "aws_instance" "myserver" {
  #count         = 2
  #ami           = "ami-06b72b3b2a773be2b"
  ami            = data.aws_ami.myami.id
  instance_type = var.instance_type
  associate_public_ip_address =true
  subnet_id=var.subnet_id
  vpc_security_group_ids = [aws_security_group.mywebsecurity.id]
  key_name="sagar2"
  user_data=file("server-script.sh")

  tags = {
    Name = "${var.env}-tf"
  }
}