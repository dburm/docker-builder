#!/bin/bash
CONTAINERNAME=mockbuild:latest
CACHEPATH=/var/cache/docker-builder/mock
DNSPARAM="--dns 172.18.80.136"
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
             sed -i 's|%EXTRAREPOURL%|${EXTRAREPO}|g' /etc/mock/centos${DIST}.cfg ;\
             mkdir -p /home/abuild/rpmbuild/build ;\
             chown -R abuild.mock /home/abuild ;\
             [[ \$(find /home/abuild/rpmbuild -maxdepth 1 -name \*.src.rpm | wc -l) -eq 0 ]] && \
                 sudo -u abuild /usr/bin/mock -r centos${DIST} --no-clean --no-cleanup-after \
                     --sources=/home/abuild/rpmbuild --resultdir=/home/abuild/rpmbuild --buildsrpm \
                     --spec=\$(find /home/abuild/rpmbuild -maxdepth 1 -name \*.spec) ;\
             rm -rf /home/abuild/rpmbuild/build ;\
             sudo -u abuild /usr/bin/mock -r centos${DIST} --no-clean --no-cleanup-after ${ENABLE_EXTRA_REPO} \
                 --resultdir=/home/abuild/rpmbuild/build \$(find /home/abuild/rpmbuild -maxdepth 1 -name \*.src.rpm) ;\
             echo \$? > /home/abuild/rpmbuild/build/exitstatus.mock ;\
             rm -f \$(find /home/abuild/rpmbuild -maxdepth 1 -name \*.src.rpm) /home/abuild/rpmbuild/build.log \
                   /home/abuild/rpmbuild/root.log /home/abuild/rpmbuild/state.log;\
             chown -R `id -u`:`id -g` /home/abuild"
