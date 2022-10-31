data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_key_pair" "key" {
  key_name   = "${var.resources_prefix}_key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.default_vpc.id
  name   = "${var.resources_prefix}_sg"
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "instance" {
  ami                         = "ami-09d3b3274b6c5d4aa"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "${var.resources_prefix}_key"
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 20
    volume_type           = "gp3"
  }
  user_data = file("./files/docker.sh")
}