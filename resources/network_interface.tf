resource "aws_network_interface" "nat_inst_eni" {
  subnet_id         = aws_subnet.public_subnet.id
  private_ips       = ["15.55.1.12"]
  security_groups   = [aws_security_group.bastion_host_security_group.id]
  source_dest_check = false
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "primary_network_interface_nat"
  }
}

resource "aws_network_interface" "eks_master_eni" {
  subnet_id         = aws_subnet.private_subnet.id
  private_ips       = ["15.55.10.12"]
  security_groups   = [aws_security_group.kubernetes_master_security_group.id]
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "primary_master_network_interface_eks"
  }
}


resource "aws_network_interface" "eks_worker_eni" {
  count = 3
  subnet_id         = aws_subnet.private_subnet.id
  private_ips       = [["15.55.10.13", "15.55.10.14", "15.55.10.15"][count.index]]
  security_groups   = [aws_security_group.kubernetes_worker_security_group.id]
  source_dest_check = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "primary_worker_network_interface_eks"
  }
}