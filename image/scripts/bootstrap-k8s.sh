#!/bin/bash
set -e

ContainerIpAddress="${1:-"172.17.0.2"}"
PodSubnet="${2:-"10.244.0.0\/16"}"
Verbosity=6

echo "Running with NodeAddress: $ContainerIpAddress, PodSubnet: $PodSubnet"

# templating!
sed "s|{{ .NodeAddress }}|$ContainerIpAddress|g;s|{{ .PodSubnet }}|$PodSubnet|g" \
  /kind/templates/kubeadm.template.conf \
  > /kind/kubeadm.conf

sed "s|{{ .PodSubnet }}|$PodSubnet|g" \
  /kind/templates/default-cni.template.yaml \
  > /etc/kubernetes/manifests/default-cni.yaml

# initializing cluster!
kubeadm init --ignore-preflight-errors=all --config=/kind/kubeadm.conf --skip-token-print --v=$Verbosity
kubectl --kubeconfig=/etc/kubernetes/admin.conf taint nodes --all node-role.kubernetes.io/master-
kubeadm join --config /kind/kubeadm.conf --ignore-preflight-errors=all --v=$Verbosity
#kubectl create --kubeconfig=/etc/kubernetes/admin.conf -f /etc/kubernetes/manifests/default-cni.yaml # moved to post-init due to flakiness
kubectl apply --kubeconfig=/etc/kubernetes/admin.conf -f /etc/kubernetes/manifests/default-storage.yaml

for image_tar in /kind/images/*
do
  ctr --namespace=k8s.io images import "$image_tar"
done
