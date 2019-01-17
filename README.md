Install Kubernetes on CentOS 7 with kubeadm
===========================================

* [Install kubeadm](https://kubernetes.io/docs/setup/independent/install-kubeadm/)

Turn OFF: **Fail on Swap** Setting
----------------------------------

**k8s** must allow a _development_ **cluster** to _swap_. There is simply not enough memory
on development machines like _laptops_.

### **kubeadm** initialization

Add the **--ignore-preflight-errors Swap** flag to the **kubeadm init** command.
This command should be run only once.

``` bash
#! /bin/bash
#
# Download and start kubeadm.
# ===================================

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
kubeadm init --ignore-preflight-errors Swap
```

### **kubelet** configuration

The **kubelet** must have its flag **--fail-swap-on=false** to allow the **cluster** to _swap_.

``` bash
$ sudo vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Allow Swap ON for local development machine!
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS --fail-swap-on=false

# Refresh configs and start kubelet (when it is NOT the master).
$ sudo systemctl daemon-reload
$ sudo systemctl start kubelet
```

Preparing **kubctl** to Use the Cluster
---------------------------------------

**kubctl** manages both **master** and **nodes** as a _non-root_ user.
There are a few things needed to make this work.

### Users must set **NO_PROXY** to the Cluster IP address

The **master** and _all_ **nodes** need this step before **kubectl** can work.

Find the **cluster IP address** in the **$HOME/.kube/config** file.
Add the IP address (without port) to the _uppercase_ **NO_PROXY** env. variable.

#### Cluster IP in config YAML

The IP address apears after the *server:* YAML label.

``` YAML
server: https://10.0.2.15:6443
```

### Choose and apply a **CNI pod network**

The **master** and _all_ **nodes** need this step.

Every **node** must apply a **CNI pod network** type to use.
This README installs the **flannel** RPM to use it.

``` bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

### Single-Machine Cluster Allows Nodes on Master

By default, the cluster will not schedule pods on the master for security reasons.
Run the **kubectl** below to schedule pods on the master and make a single-machine Kubernetes cluster
for development.

``` bash
kubectl taint nodes --all node-role.kubernetes.io/master-
```
