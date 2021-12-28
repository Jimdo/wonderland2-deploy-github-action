#!/usr/bin/env bash

set -euo pipefail

function log() {
    echo "$(date -u) $*"
}

if [ $# -lt 5 ]; then
    log "Not enough arguments"
    exit 1
fi

log "Setting WONDERLAND_GITHUB_TOKEN"
export WONDERLAND_GITHUB_TOKEN="$1"

log "Setting ssh key"
mkdir -p /root/.ssh/
echo "$2" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
echo "StrictHostKeyChecking no" > /root/.ssh/config

service_name=$(yq eval '.metadata.name' "$4")

log "Deploying $service_name to Wonderland 2"
wl --workspace="$3" kubectl apply -f "$4"
log "Waiting for service to become available"
wl --workspace="$3" kubectl rollout status deploy "$service_name" --timeout="$5"
log "Deployed $service_name to Wonderland 2 successfully"
log "Getting service status"
wl --workspace="$3" kubectl get ws "$service_name"
