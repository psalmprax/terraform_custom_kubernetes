#!/bin/bash

# Install Kubernetes prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2

# Add the Kubernetes repository key
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Add the Kubernetes repository
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
sudo apt-get update
sudo apt-get install -y kubeadm kubelet kubectl

# Initialize the Kubernetes control plane
sudo kubeadm init

# Copy the kubeconfig file to the user's home directory
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy a pod network
kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

sudo mkdir -p /home/ubuntu/targets
sudo chown -R ubuntu:ubuntu /home/ubuntu/targets/

join_command=$(kubeadm token create --print-join-command)
echo $join_command > /home/ubuntu/targets/join_command.sh
sudo chown -R ubuntu:ubuntu /home/ubuntu/targets
sudo chown -R ubuntu:ubuntu /home/ubuntu/targets/join_command.sh

sudo apt-get install awscli -y
# sudo aws s3 cp /home/ubuntu/targets/join_command.sh s3://airsamtest/targets/
sudo aws s3 sync /home/ubuntu/targets s3://airsamtest/targets
