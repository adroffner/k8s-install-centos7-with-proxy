#! /bin/bash
#
# Create Private Docker Registry in k8s.
# ============================================================
# Kubernetes needs to know where a private Docker registry is.
# See: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
# ============================================================

SECRET_NAME="devregistry"

DOCKER_HOST="dockercentral.it.att.com"
DOCKER_PORT=5100

DOCKER_USER="m12292@argos.dev.att.com"

# Get DOCKER_PASSWORD.
echo -n "(${DOCKER_USER}) Docker Password: "
read -s DOCKER_PASSWORD
echo

kubectl create secret docker-registry "${SECRET_NAME}" \
	--docker-server="${DOCKER_HOST}:${DOCKER_PORT}" \
	--docker-username="${DOCKER_USER}" \
	--docker-password="${DOCKER_PASSWORD}" \
	--docker-email="nobody@example.com"
