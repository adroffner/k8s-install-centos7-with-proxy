#! /bin/bash
#
# Install K8s kubeadm on CentOS 7
#
# Setting SELinux in permissive mode effectively disables it.
# This is required to allow containers to access the host filesystem,
# which is needed by pod networks for example.
# You have to do this until SELinux support is improved in the kubelet.
# =========================================================
# Set SELinux in permissive mode (effectively disabling it)
# =========================================================

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
