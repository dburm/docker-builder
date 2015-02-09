#!/bin/bash
. $(dirname $(readlink -f $0))/config
CONTAINERNAME=mockbuild:latest
CACHEPATH=/var/cache/docker-builder/mock
[ -z "${DIST}" ] && DIST=6

[ -n "$EXTRAREPO" ] && ENABLE_EXTRA_REPO="--enablerepo=extra"
[ -z "$EXTRAREPO" ] && EXTRAREPO="http://fakeurl/"

docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}:/srv/mock:ro \
    -v $(pwd):/home/abuild/rpmbuild ${CONTAINERNAME} \
    bash -x -c "mkdir -p /srv/tmpfs/{lib,cache} ;\
             mount -t tmpfs overlay /srv/tmpfs/lib ;\
             mount -t tmpfs overlay /srv/tmpfs/cache ;\
             mount -t aufs -o br=/srv/tmpfs/lib:/srv/mock/lib none /var/lib/mock/ ;\
             mount -t aufs -o br=/srv/tmpfs/cache/:/srv/mock/cache none /var/cache/mock/ ;\
             sed -i 's|%EXTRAREPOURL%|${EXTRAREPO}|g' /etc/mock/centos-${DIST}-x86_64.cfg ;\
             mkdir -p /home/abuild/rpmbuild/build ;\
             chown -R abuild.mock /home/abuild ;\
             [[ \$(ls /home/abuild/rpmbuild/*.src.rpm | wc -l) -eq 0 ]] && \
                 su - abuild -c 'mock -r centos-${DIST}-x86_64 --no-clean --no-cleanup-after \
                     --sources=/home/abuild/rpmbuild --resultdir=/home/abuild/rpmbuild --buildsrpm \
                     --spec=\$(ls /home/abuild/rpmbuild/*.spec)' ;\
             rm -rf /home/abuild/rpmbuild/build ;\
             su - abuild -c 'mock -r centos-${DIST}-x86_64 --no-clean --no-cleanup-after ${ENABLE_EXTRA_REPO} \
                 --resultdir=/home/abuild/rpmbuild/build \$(ls /home/abuild/rpmbuild/*.src.rpm)' ;\
             echo \$? > /home/abuild/rpmbuild/build/exitstatus.mock ;\
             umount -f /var/cache/mock /var/lib/mock /srv/tmpfs/cache /srv/tmpfs/lib ;\
             rm -rf /srv/tmpfs ;\
             rm -f /home/abuild/rpmbuild/\*.src.rpm /home/abuild/rpmbuild/{build,root,state}.log;\
             chown -R `id -u`:`id -g` /home/abuild"
