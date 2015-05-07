#!/bin/bash
. $(dirname $(readlink -f $0))/config
CONTAINERNAME=sbuild:latest
CACHEPATH=/var/cache/docker-builder/sbuild
[ -z "$DIST" ] && DIST=trusty
docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}:/srv/images ${CONTAINERNAME} \
    bash -c "sbuild-update -udcar ${DIST}"
