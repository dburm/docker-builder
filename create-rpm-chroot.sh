#!/bin/bash
. $(dirname $(readlink -f $0))/config
CONTAINERNAME=mockbuild:latest
CACHEPATH=/var/cache/docker-builder/mock
[ -z "${DIST}" ] && DIST=6
docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}/cache:/var/cache/mock -v ${CACHEPATH}/lib:/var/lib/mock ${CONTAINERNAME} \
    bash -c "chown -R abuild:mock /var/cache/mock /var/lib/mock; \
             chmod -R g+s /var/cache/mock /var/lib/mock; \
             sed -i 's|%EXTRAREPOURL%|http://fakeurl/|g' /etc/mock/centos-${DIST}-x86_64.cfg ;\
             su - abuild -c 'mock -r centos-${DIST}-x86_64 -v --init'"
