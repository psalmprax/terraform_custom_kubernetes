#!/bin/bash

# update system packages
sudo yum update -y

# install required packages
sudo yum install -y apt-transport-https ca-certificates curl software-properties-common

# add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add Docker repository to package sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# add Kubernetes GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# add Kubernetes repository to package sources
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# update package sources
sudo yum update -y

# https://docs.docker.com/engine/install/ubuntu/
sudo yum install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo yum update
# sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
docker --version
# https://docs.docker.com/compose/install/
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
# https://stackoverflow.com/questions/25043883/comparing-two-ip-addresses-in-bash
# First diasbale swap
sudo swapoff -a

# And then to disable swap on startup in /etc/fstab
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# install Docker and Kubernetes components
sudo yum install -y kubelet kubeadm kubectl

# configure Docker to use systemd as the cgroup driver
sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl enable docker
sudo systemctl restart docker