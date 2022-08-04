#!/usr/bin/env bash

apt update
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt install -y docker-ce 
# adding user vagrant to docker group
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start  docker
to-be-tested from here
sudo ufw disable
sudo swapoff -a

#installing kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo sudo apt install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
sudo systemctl start kubelet

#installing helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install -y helm
helm repo add bitnami https://charts.bitnami.com/bitnami

#installing k3s
curl -sfL https://get.k3s.io | sh -
sudo chown -R $USER:$USER /etc/rancher/k3s/
helm --kubeconfig /etc/rancher/k3s/k3s.yaml list
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
