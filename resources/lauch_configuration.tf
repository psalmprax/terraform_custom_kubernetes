resource "aws_launch_configuration" "kubernetes_worker_alc" {
  name_prefix     = "kubernetes-aws-asg-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
#  user_data       = file("../../resources/user_data/worker_installation.sh")
  security_groups = [aws_security_group.kubernetes_worker_security_group.id]

  depends_on = [aws_instance.kubernetes_master]

  iam_instance_profile = aws_iam_instance_profile.instance_s3_acces_profile.name

#  credit_specification {
#    cpu_credits = "unlimited"
#  }

  lifecycle {
    create_before_destroy = true
  }
#  tags = {
#    Name = "k8s-worker-${count.index}"
#  }

}