#!/usr/bin/env bash

set -uo pipefail

function log() {
  echo "$(date -u) $*"
}

if [ $# -lt 6 ]; then
  log "Not enough arguments"
  exit 1
fi

log "Setting WONDERLAND_GITHUB_TOKEN"
export WONDERLAND_GITHUB_TOKEN="$1"

log "Setting ssh key"
mkdir -p /root/.ssh/
echo "$2" >/root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
echo "StrictHostKeyChecking no" >/root/.ssh/config

service_name=$(yq eval '.metadata.name' "$4")

if $6 == "true"; then
  log "Deleting $service_name from Wonderland 2"
  wl --environment="$3" kubectl delete -f "$4"
else
  log "Deploying $service_name to Wonderland 2"
  wl --environment="$3" kubectl apply -f "$4"
  log "Waiting for service to become available"
  WAIT_TIME=0
  until [ $WAIT_TIME -lt 10 ] || wl --environment="$3" kubectl get deployment "$service_name" 2>/dev/null; do
    sleep $((WAIT_TIME ++))
    log "waiting ${WAIT_TIME}s for deployment to become available"
  done
  if [ "$WAIT_TIME" -lt 10 ]; then
    wl --environment="$3" kubectl rollout status deploy "$service_name" --timeout="$5"
    retVal=$?
    if [ $retVal -ne 0 ]; then
      log "Deployment failed or did not succeed within the specified timeout. Service name: $service_name"
      log "For hints how to debug this, please take a look at: https://backstage.jimdex.net/docs/default/component/wonderland2-k8s-operator/How-To/Debug/"
      exit $retVal
    fi
    log "Deployed $service_name to Wonderland 2 successfully"
    log "Getting service status"
    wl --environment="$3" kubectl get ws "$service_name"
  fi
fi
