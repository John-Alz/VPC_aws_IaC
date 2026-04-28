resource "aws_security_group" "private_ec2_sg" {
  name        = "private-ec2-sg"
  description = "Security group for private EC2"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-ec2-sg"
  }
}

resource "aws_instance" "private_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile = var.iam_instance_profile
  tags = {
    Name = "private-ec2"
  }
}

# Tunel de coneccion

resource "aws_ec2_instance_connect_endpoint" "eice" {
  subnet_id = var.subnet_id
  tags = {
    Name = "nequi-eic-endpoint"
  }
}

resource "aws_security_group_rule" "allow_ssh_from_eice" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.private_ec2_sg.id
}
