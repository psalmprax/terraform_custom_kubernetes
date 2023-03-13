resource "aws_security_group" "bastion_host_security_group" {
  name_prefix = "bastion-host-sg-"
  description = "Allow SSH bastion inbound traffic"
  vpc_id      = aws_vpc.kubernetes_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = [aws_vpc.kubernetes_vpc.cidr_block]
#  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.kubernetes_vpc.cidr_block]
  }

#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = [aws_security_group.kubernetes_master_security_group.id]
#  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion-host-sg"
  }
}


resource "aws_security_group" "kubernetes_master_security_group" {
  name_prefix = "kubernetes-master-sg-"
  description = "Allow kubernetes_master inbound traffic"
  vpc_id      = aws_vpc.kubernetes_vpc.id

    # Created an inbound rule for ping
  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }

#  ingress {
#    from_port       = 6443
#    to_port         = 6443
#    protocol        = "tcp"
#    security_groups = [aws_security_group.bastion_host_security_group.id]
#  }

  ingress {
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.kubernetes_worker_security_group.id]
  }

  ingress {
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.kubernetes_worker_security_group.id]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.kubernetes_worker_security_group.id]
  }
#  ingress {
#    from_port       = 10250
#    to_port         = 10250
#    protocol        = "tcp"
#    security_groups = [aws_security_group.bastion_host_security_group.id]
#  }


  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.bastion_host_security_group.id]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "kubernetes-master-sg"
  }
}


# Define the security group for the Kubernetes workers
resource "aws_security_group" "kubernetes_worker_security_group" {
  name_prefix = "kubernetes-worker-sg-"
  description = "Allow kubernetes_worker inbound traffic"
  vpc_id      = aws_vpc.kubernetes_vpc.id
  ingress {
    from_port   = 10250
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
#    security_groups = [aws_security_group.kubernetes_master_security_group.id]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
#    security_groups = [aws_security_group.kubernetes_master_security_group.id]
  }

#   ingress {
#    from_port       = 0
#    to_port         = 0
#    protocol        = "-1"
#    security_groups = [aws_security_group.bastion_host_security_group.id]
#  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    tags = {
    Name = "kubernetes-worker-sg"
  }
}
