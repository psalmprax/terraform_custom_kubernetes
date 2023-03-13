resource "aws_autoscaling_group" "terramino" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.kubernetes_worker_alc.name
  vpc_zone_identifier  = [aws_subnet.private_subnet.id]
#  tags = {
#    Name_ = "k8s-worker-"
#    Name_D = "worker_node_"
#  }
}