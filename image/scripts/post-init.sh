#!/bin/bash
set -e

kubectl create --kubeconfig=/etc/kubernetes/admin.conf -f /etc/kubernetes/manifests/default-cni.yaml
