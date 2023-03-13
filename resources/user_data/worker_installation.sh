#!/bin/bash
# Disable swap
sudo swapoff -a

# Comment out swap entry in /etc/fstab
sudo sed -i '/swap/d' /etc/fstab
sudo sed -i 's/.*swap.*/#&/' /etc/fstab

# Verify that swap is disabled
free -h

# Install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install

# Install docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# Install kubeadm, kubelet, and kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# sudo kubeadm init --ignore-preflight-errors=all
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

# Join worker nodes to the master node
sleep 120
aws s3 cp s3://airsamtest/targets/join_command.sh /tmp/join_command.sh

# Retrieve the join command from the master node
while [ ! -f /tmp/join_command.sh ]; do sleep 5; done
join_command=$(cat /tmp/join_command.sh)

# Join the Kubernetes cluster as a worker node
temp_cmd=$(tr '<>\\#%|?*' ' ' <<<"$join_command")
final_cmd="sudo $temp_cmd --v=5"
$final_cmd