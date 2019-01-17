#! /bin/bash
#
# User Kubernetes Configuration Set-up.
# =====================================

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
