#!/bin/bash

# update system packages
sudo apt-get update -y

# install required packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add Docker repository to package sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# add Kubernetes GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# add Kubernetes repository to package sources
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# update package sources
sudo apt-get update -y

# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
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
sudo apt-get install -y kubelet kubeadm kubectl

# configure Docker to use systemd as the cgroup driver
sudo rm /etc/containerd/config.toml
sudo systemctl daemon-reload
sudo systemctl restart containerd
sudo systemctl restart kubelet
#kubeadm init
# configure Docker to use systemd as the cgroup driver
#sudo tee /etc/docker/daemon.json <<EOF
#{
#"exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF
sudo systemctl enable docker
sudo systemctl restart docker

sudo apt  install awscli -y
# configure the worker nodes
# join the Kubernetes cluster as a worker node
# sudo kubeadm init --ignore-preflight-errors=all
#sudo rm /etc/containerd/config.toml
#sudo systemctl restart containerd

# Join worker nodes to the master node
sleep 120
aws s3 cp s3://airsamtest/targets/join_command.sh /tmp/join_command.sh

# Retrieve the join command from the master node
while [ ! -f /tmp/join_command.sh ]; do sleep 5; done
join_command=$(cat /tmp/join_command.sh)

# Join the Kubernetes cluster as a worker node
temp_cmd=$(tr "<>\\#%|?*" " " <<<"$join_command")
final_cmd="sudo $temp_cmd --v=5"
$final_cmd
