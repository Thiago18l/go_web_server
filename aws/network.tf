resource "aws_security_group" "sg-ec2" {
  name        = "${var.name}-ec2"
  description = "Allow all outgoing traffic to everywhere"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

