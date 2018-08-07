#!/bin/bash

#arguments to bash file
CLIENT_IP=$1
TOKEN=$2

# start kubernetes cluster

wget https://cdn.rawgit.com/kubernetes-sigs/kubeadm-dind-cluster/master/fixed/dind-cluster-v1.8.sh
chmod +x dind-cluster-v1.8.sh

# start the cluster
./dind-cluster-v1.8.sh up

# Install heapster for metrics dashboard
if [[ -d heapster ]]; then
    echo "heapster directory exists"
else    
    git clone https://github.com/kubernetes/heapster.git
fi
kubectl create -f heapster/deploy/kube-config/influxdb
kubectl create -f heapster/deploy/kube-config/rbac/heapster-rbac.yaml

# Install metrics server for CPU and memory usage 
if [[ -d metrics-server ]]; then
    echo "metrics server directory exists"
else    
    git clone https://github.com/kubernetes-incubator/metrics-server.git
fi
kubectl create -f metrics-server/deploy/1.8+/

# Deploying mashling app
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f autoscale.yml

output=$(watch -n 10 ./register-consul.sh $CLIENT_IP $TOKEN) & pid=$1
echo "cron job is executing in backend for every 10 seconds to update the service status to consul. For cronjob status hit 'ps -a' command on terminal"