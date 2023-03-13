resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.eks_key_pair.key_name
  availability_zone = aws_subnet.public_subnet.availability_zone
#  availability_zone = aws_subnet.public_subnet[count.index].availability_zone
#  vpc_security_group_ids   = [aws_security_group.bastion_host_security_group.id]

  network_interface {
    network_interface_id = aws_network_interface.nat_inst_eni.id
    device_index         = 0
  }
  user_data              = file("../../resources/user_data/bastion_installation.sh")

  #  user_data = <<-EOL
  #  #!/bin/bash -xe
  #  sudo yum install cloud-init
  #  sudo yum update -y
  #  sudo sysctl -w net.ipv4.ip_forward=1
  #  sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  #  sudo yum install iptables-services -y
  #  sudo service iptables save
  #  EOL
  # Tags
  tags = {
    Name = "kubernetes-bastion"
  }
}