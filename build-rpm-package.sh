#!/bin/bash
. $(dirname $(readlink -f $0))/config
CONTAINERNAME=mockbuild:latest
CACHEPATH=/var/cache/docker-builder/mock
[ -z "${DIST_VERSION}" ] && DIST_VERSION=7

EXTRACMD=":"
if [ -n "$EXTRAREPO" ] ; then
   EXTRACMD="sed -i"
   OLDIFS="$IFS"
   IFS='|'
   for repo in $EXTRAREPO ; do
     IFS="$OLDIFS"
     reponame=${repo%%,*}
     repourl=${repo##*,}
     EXTRACMD="$EXTRACMD -e \"$ i[${reponame}]\nname=${reponame}\nbaseurl=${repourl}\ngpgcheck=0\nenabled=1\nskip_if_unavailable=1\""
     IFS='|'
   done
   IFS="$OLDIFS"
   EXTRACMD="$EXTRACMD /etc/mock/centos-${DIST_VERSION}-x86_64.cfg"
fi

docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}:/srv/mock:ro \
    -v $(pwd):/home/abuild/rpmbuild ${CONTAINERNAME} \
    bash -x -c "mkdir -p /srv/tmpfs/{lib,cache} ;\
             mount -t tmpfs overlay /srv/tmpfs/lib ;\
             mount -t tmpfs overlay /srv/tmpfs/cache ;\
             mount -t aufs -o br=/srv/tmpfs/lib:/srv/mock/lib none /var/lib/mock/ ;\
             mount -t aufs -o br=/srv/tmpfs/cache/:/srv/mock/cache none /var/cache/mock/ ;\
             $EXTRACMD ;\
             mkdir -p /home/abuild/rpmbuild/build ;\
             chown -R abuild.mock /home/abuild ;\
             [[ \$(ls /home/abuild/rpmbuild/*.src.rpm | wc -l) -eq 0 ]] && \
                 su - abuild -c 'mock -r centos-${DIST_VERSION}-x86_64 --no-clean --no-cleanup-after \
                     --sources=/home/abuild/rpmbuild --resultdir=/home/abuild/rpmbuild --buildsrpm \
                     --spec=\$(ls /home/abuild/rpmbuild/*.spec)' ;\
             rm -rf /home/abuild/rpmbuild/build ;\
             su - abuild -c 'mock -r centos-${DIST_VERSION}-x86_64 --no-clean --no-cleanup-after \
                 --resultdir=/home/abuild/rpmbuild/build \$(ls /home/abuild/rpmbuild/*.src.rpm)' ;\
             echo \$? > /home/abuild/rpmbuild/build/exitstatus.mock ;\
             umount -f /var/cache/mock /var/lib/mock /srv/tmpfs/cache /srv/tmpfs/lib ;\
             rm -rf /srv/tmpfs ;\
             rm -f /home/abuild/rpmbuild/\*.src.rpm /home/abuild/rpmbuild/{build,root,state}.log;\
             chown -R `id -u`:`id -g` /home/abuild"
