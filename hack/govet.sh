#!/bin/sh

set -eux

IS_CONTAINER=${IS_CONTAINER:-false}
CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-podman}"

if [ "${IS_CONTAINER}" != "false" ]; then
  export XDG_CACHE_HOME=/tmp/.cache
  mkdir /tmp/unit
  cp -r ./* /tmp/unit
  cd /tmp/unit
  make vet
else
  "${CONTAINER_RUNTIME}" run --rm \
    --env IS_CONTAINER=TRUE \
    --volume "${PWD}:/metal3-ipam:ro,z" \
    --entrypoint sh \
    --workdir /metal3-ipam \
    registry.hub.docker.com/library/golang:1.16 \
    /metal3-ipam/hack/govet.sh
fi;
