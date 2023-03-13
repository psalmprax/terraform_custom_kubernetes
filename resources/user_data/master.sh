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

# install Docker and Docker Compose
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# install kubectl, kubelet and kubeadm
sudo apt-get install -y kubectl kubelet kubeadm

#sudo sed -i '/ExecStart=/ s/$/ --container-runtime-endpoint=unix:\/\/\/var\/run\/docker.sock/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
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

# initialize Kubernetes on the master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=$(ec2metadata --local-ipv4)

# configure kubectl for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install a network plugin for pod networking
#sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
sudo kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


# disable swap on the system
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# create a directory for storing join command script
sudo mkdir -p /home/ubuntu/targets
sudo chown -R ubuntu:ubuntu /home/ubuntu/targets/

# generate join command and store in a script
join_command=$(sudo kubeadm token create --print-join-command)
echo $join_command > /home/ubuntu/targets/join_command.sh
sudo chown -R ubuntu:ubuntu /home/ubuntu/targets
sudo chown -R ubuntu:ubuntu /home/ubuntu/targets/join_command.sh

# install AWS CLI and sync the join command script to S3 bucket
sudo apt-get install -y awscli
sudo aws s3 sync /home/ubuntu/targets s3://airsamtest/targets




##!/bin/bash
#
## update system packages
#sudo apt-get update -y
#
## install required packages
#sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#
## add Docker GPG key
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#
## add Docker repository to package sources
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#
## add Kubernetes GPG key
#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#
## add Kubernetes repository to package sources
#echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#
## update package sources
#sudo apt-get update -y
#
## https://docs.docker.com/engine/install/ubuntu/
#sudo apt-get install \
#    ca-certificates \
#    curl \
#    gnupg \
#    lsb-release -y
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#echo \
#    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update
## sudo apt-get install docker-ce docker-ce-cli containerd.io -y
#sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
#docker --version
## https://docs.docker.com/compose/install/
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose
#docker-compose --version
## https://stackoverflow.com/questions/25043883/comparing-two-ip-addresses-in-bash
## First diasbale swap
#sudo swapoff -a
#
## And then to disable swap on startup in /etc/fstab
#sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
#
## install Docker and Kubernetes components
#sudo apt-get install -y kubelet kubeadm kubectl
#
## configure Docker to use systemd as the cgroup driver
#sudo cat <<EOF | sudo tee /etc/docker/daemon.json
#{
#  "exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF
#sudo systemctl enable docker
#sudo systemctl restart docker
#
## initialize Kubernetes on the master node
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=$(ec2metadata --local-ipv4)
#
## configure kubectl for the current user
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
## install a network plugin for pod networking
#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
#
#sudo mkdir -p /home/ubuntu/targets
#sudo chown -R ubuntu:ubuntu /home/ubuntu/targets/
#
#join_command=$(sudo kubeadm token create --print-join-command)
#echo $join_command > /home/ubuntu/targets/join_command.sh
#sudo chown -R ubuntu:ubuntu /home/ubuntu/targets
#sudo chown -R ubuntu:ubuntu /home/ubuntu/targets/join_command.sh
#
#sudo apt-get install awscli -y
## sudo aws s3 cp /home/ubuntu/targets/join_command.sh s3://airsamtest/targets/
#sudo aws s3 sync /home/ubuntu/targets s3://airsamtest/targets