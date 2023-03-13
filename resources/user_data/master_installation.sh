#!/bin/bash
# Install kubeadm, kubelet, and kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

## Install docker and Kubernetes
HOME=/home/ubuntu
sudo mkdir -p /home/ubuntu/installer_folder
sudo git clone -b master https://psalmprax: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@github.com/psalmprax/eks_install_script.git /home/ubuntu/installer_folder
sudo chown -R ubuntu:ubuntu /home/ubuntu/installer_folder
sudo chown -R ubuntu:ubuntu /home/ubuntu/installer_folder/install.sh
sudo chown -R ubuntu:ubuntu /home/ubuntu/installer_folder/master_node_install.sh
sudo chmod -R 777 /home/ubuntu/installer_folder/master_node_install.sh /home/ubuntu/installer_folder/install.sh
sh /home/ubuntu/installer_folder/master_node_install.sh
