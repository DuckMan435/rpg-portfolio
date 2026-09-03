resource "aws_instance" "bastion" {
  ami           = "ami-05d38da78ce859165"  # Amazon Linux 2023 us-west-2
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public[0].id
  
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name = "forge-bastion-key"

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.vpc_name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

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