#provider "aws" {
#  region = "us-west-2"
#}
#
#resource "aws_security_group" "kubernetes" {
#  name_prefix = "kubernetes"
#}
#
#resource "aws_instance" "kubernetes_master" {
#  ami           = "ami-0c55b159cbfafe1f0"
#  instance_type = "t2.micro"
#  key_name      = "my_key"
#  user_data     = <<-EOF
#    #!/bin/bash
#    # Install kubeadm, kubelet, and kubectl
#    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#    sudo apt-get update
#    sudo apt-get install -y kubelet kubeadm kubectl
#    # Initialize the Kubernetes cluster
#    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
#    # Copy the kubeconfig file to the default location
#    mkdir -p $HOME/.kube
#    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#    sudo chown $(id -u):$(id -g) $HOME/.kube/config
#    # Install a pod network add-on
#    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#    # Get the join command and print it to the console
#    join_command=$(kubeadm token create --print-join-command)
#    echo $join_command > /tmp/join-command
#  EOF
#
#  vpc_security_group_ids = [aws_security_group.kubernetes.id]
#
#  provisioner "local-exec" {
#    command = "sleep 60 && scp -o StrictHostKeyChecking=no -i my_key.pem ec2-user@${self.public_ip}:/tmp/join-command /tmp"
#  }
#}
#
#resource "aws_instance" "kubernetes_worker_1" {
#  ami           = "ami-0c55b159cbfafe1f0"
#  instance_type = "t2.micro"
#  key_name      = "my_key"
#  user_data     = <<-EOF
#    #!/bin/bash
#    # Install kubeadm, kubelet, and kubectl
#    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#    sudo apt-get update
#    sudo apt-get install -y kubelet kubeadm kubectl
#    # Retrieve the join command from the master node
#    while [ ! -f /tmp/join-command ]; do sleep 10; done
#    join_command=$(cat /tmp/join-command)
#    # Join the Kubernetes cluster as a worker node
#    sudo $join_command
#  EOF
#
#  vpc_security_group_ids = [aws_security_group.kubernetes.id]
#}
#
##resource "aws_instance" "kubernetes_worker_2" {
##  ami           = "ami-0c55b159cbfafe1f0"
##  instance_type = "t2.micro"
##  key_name      = "my_key"
##  user_data     = <<-EOF
##    #!/bin/bash
##    # Install kubeadm, kubelet, and kubectl
##    curl -
