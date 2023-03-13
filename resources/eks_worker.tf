# Resource Configuration
resource "aws_instance" "kubernetes_worker" {
  count             = 3
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  availability_zone = aws_subnet.private_subnet.availability_zone
  key_name          = aws_key_pair.eks_key_pair.key_name

  network_interface {
    network_interface_id = aws_network_interface.eks_worker_eni[count.index].id
    device_index         = 0
  }
  # User Data
#  user_data              = file("../../resources/user_data/worker_installation.sh")
  depends_on = [aws_instance.kubernetes_master]

  iam_instance_profile = aws_iam_instance_profile.instance_s3_acces_profile.name

  credit_specification {
    cpu_credits = "unlimited"
  }

  lifecycle {
    ignore_changes        = [ami]
    create_before_destroy = true
  }
  tags = {
    Name_ = "k8s-worker-${count.index}"
    Name = "worker_node_${count.index}"
  }
}
