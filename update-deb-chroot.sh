#!/bin/bash
CONTAINERNAME=sbuild:latest
CACHEPATH=/var/cache/docker-builder/sbuild
DNSPARAM="--dns 172.18.80.136"
[ -z "$DIST" ] && DIST=precise
docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}:/srv/images ${CONTAINERNAME} \
    bash -c "sbuild-update -udcar ${DIST}"
