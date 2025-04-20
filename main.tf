provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ubuntu_ec2" {
  ami                    = "ami-0c1ac8a41498c1a9c"
  instance_type          = "t3.micro"
  key_name               = # your key goes here
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  user_data              = file("init.sh")

  tags = {
    Name = "MilesEC2"
  }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http_v2"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "extra_volume" {
  availability_zone = "eu-north-1a"
  size              = 1
  type              = "gp3"
  tags = {
    Name = "MilesExtraVolume"
  }
}

resource "aws_volume_attachment" "ebs_attached" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.extra_volume.id
  instance_id = aws_instance.ubuntu_ec2.id
}
