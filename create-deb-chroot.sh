#!/bin/bash
CONTAINERNAME=sbuild:latest
CACHEPATH=/var/cache/docker-builder/sbuild
DNSPARAM="--dns 172.18.80.136"
MIRROR="http://mirror.yandex.ru/ubuntu"
[ -z "${DIST}" ] && DIST=precise
docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}:/srv/images ${CONTAINERNAME} \
    bash -c "rm -f /etc/schroot/chroot.d/*; \
             sbuild-createchroot ${DIST} /srv/images/${DIST}-amd64 ${MIRROR}; \
             echo deb ${MIRROR} ${DIST} main universe multiverse restricted > /srv/images/${DIST}-amd64/etc/apt/sources.list; \
             echo deb ${MIRROR} ${DIST}-updates main universe multiverse restricted >> /srv/images/${DIST}-amd64/etc/apt/sources.list; \
             sbuild-update -udcar ${DIST}; \
             echo '#!/bin/bash' > /srv/images/${DIST}-amd64/usr/bin/apt-add-repo; \
             echo 'echo \$* >> /etc/apt/sources.list' >> /srv/images/${DIST}-amd64/usr/bin/apt-add-repo; \
             chmod +x /srv/images/${DIST}-amd64/usr/bin/apt-add-repo"
