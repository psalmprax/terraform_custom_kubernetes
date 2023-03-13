# Resource Configuration
resource "aws_instance" "kubernetes_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = aws_subnet.private_subnet.availability_zone
  key_name          = aws_key_pair.eks_key_pair.key_name

  network_interface {
    network_interface_id = aws_network_interface.eks_master_eni.id
    device_index         = 0
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/psalmprax")
    host        = self.private_ip

    bastion_host        = aws_instance.bastion.public_ip
    bastion_user        = "ec2-user"
    bastion_private_key = file("~/.ssh/psalmprax")
#    bastion_timeout     = "1h"
  }
  user_data              = file("../../resources/user_data/master.sh")
  iam_instance_profile = aws_iam_instance_profile.instance_s3_acces_profile.name

#  provisioner "local-exec" {
#    command = "scp -o 'ProxyCommand ssh -i ~/.ssh/psalmprax -o StrictHostKeyChecking=no -W %h:%p ec2-user@${aws_instance.bastion.public_ip}' -o StrictHostKeyChecking=no ~/.ssh/psalmprax ubuntu@${self.private_ip}:~/.ssh"
#  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  lifecycle {
    ignore_changes        = [ami]
    create_before_destroy = true
  }
  # Tags
  tags = {
    Name_ = "kubernetes-master"
    Name                                 = "golinuxcloud-k8s-master"
    "kubernetes.io/cluster/golinuxcloud" = "owned"
  }
}

resource "aws_key_pair" "eks_key_pair" {
  key_name   = "eks_key_pair"
  public_key = file("/home/psalmprax/.ssh/psalmprax.pub")
}


