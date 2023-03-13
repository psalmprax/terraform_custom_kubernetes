#!/bin/bash
# Install kubeadm, kubelet, and kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
# sudo apt-get install -y kubelet kubeadm kubectl
# Initialize the Kubernetes cluster
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16
# Copy the kubeconfig file to the default location
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
## Install docker and Kubernetes
HOME=/home/ubuntu
sudo mkdir -p /home/ubuntu/installer_folder
sudo git clone -b master https://psalmprax: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@github.com/psalmprax/eks_install_script.git /home/ubuntu/installer_folder
sudo chown -R ubuntu:ubuntu /home/ubuntu/installer_folder
sudo chown -R ubuntu:ubuntu /home/ubuntu/installer_folder/install.sh
sudo chown -R ubuntu:ubuntu /home/ubuntu/installer_folder/master_node_install.sh
sudo chmod -R 777 /home/ubuntu/installer_folder/master_node_install.sh /home/ubuntu/installer_folder/install.sh
sh /home/ubuntu/installer_folder/master_node_install.sh
## Install a pod network add-on
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
## Get the join command and print it to the console
# join_command=$(kubeadm token create --print-join-command)
# echo $join_command > /home/ubuntu/targets/join-command.sh
# aws s3 sync /home/ubuntu/targets s3://airsamtest/targets