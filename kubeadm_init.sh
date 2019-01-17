#! /bin/bash
#
# Download k8s images and start kubeadm.
# ================================================

# Set HTTP Proxies and pull-down kubeadm images.
export http_proxy="http://one.proxy.att.com:8080"
export https_proxy="http://one.proxy.att.com:8080"
kubeadm config images pull

# Add missing "flannel" Docker image.
docker pull quay.io/coreos/flannel:v0.10.0-amd64

# Clear HTTP Proxies and start it.
# (kubeadm and kublet can't find each other over a proxy.)
unset http_proxy
unset https_proxy
kubeadm init \
	--ignore-preflight-errors Swap \
	--pod-network-cidr=10.244.0.0/16  # flannel CNI

