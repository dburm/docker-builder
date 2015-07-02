FROM ubuntu:trusty
MAINTAINER dburmistrov@mirantis.com

ENV MIRROR http://mirror.yandex.ru/ubuntu
ENV NAMESERV 172.18.80.136
ENV DIST trusty

VOLUME ["/srv/images", "/srv/source"]

COPY sbuild-key.pub /var/lib/sbuild/apt-keys/sbuild-key.pub
COPY sbuild-key.sec /var/lib/sbuild/apt-keys/sbuild-key.sec

RUN rm /etc/apt/sources.list.d/proposed.list ;\
    echo -e "\nnameserver $NAMESERV\n" >> /etc/resolv.conf ;\
    echo "deb $MIRROR $DIST main universe multiverse restricted" > /etc/apt/sources.list ;\
    echo "deb $MIRROR $DIST-updates main universe multiverse restricted" >> /etc/apt/sources.list ;\
    apt-get update ;\
    apt-get -y install sbuild debhelper git-buildpackage ;\
    apt-get clean ;\
    mkdir -p /srv/build ;\
    sed -i '/^1/d' /etc/sbuild/sbuild.conf ;\
    echo "\$build_arch_all = 1;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$log_colour = 0;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$apt_allow_unauthenticated = 1;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$apt_update = 0;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$apt_clean = 0;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$build_source = 1;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$build_dir = '/srv/build';" >> /etc/sbuild/sbuild.conf ;\
    echo "\$log_dir = '/srv/build';" >> /etc/sbuild/sbuild.conf ;\
    echo "\$stats_dir = '/srv/build';" >> /etc/sbuild/sbuild.conf ;\
    echo "\$verbose = 100;" >> /etc/sbuild/sbuild.conf ;\
    echo "\$mailprog = '/bin/true';" >> /etc/sbuild/sbuild.conf ;\
    echo "\$purge_build_deps = 'never';" >> /etc/sbuild/sbuild.conf ;\
    echo "1;" >> /etc/sbuild/sbuild.conf ;\ 
    echo "#!/bin/sh" >> /etc/schroot/setup.d/04tmpfs ;\
    echo ". \"\$SETUP_DATA_DIR/common-data\"" >> /etc/schroot/setup.d/04tmpfs ;\
    echo ". \"\$SETUP_DATA_DIR/common-functions\"" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "#. \"\$SETUP_DATA_DIR/common-config\"" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "if [ \$STAGE = \"setup-start\" ]; then" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "  mount -t tmpfs overlay /var/lib/schroot/union/overlay" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "elif [ \$STAGE = \"setup-recover\" ]; then" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "  mount -t tmpfs overlay /var/lib/schroot/union/overlay" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "elif [ \$STAGE = \"setup-stop\" ]; then" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "  umount -f /var/lib/schroot/union/overlay" >> /etc/schroot/setup.d/04tmpfs ;\
    echo "fi" >> /etc/schroot/setup.d/04tmpfs ;\
    chmod +x /etc/schroot/setup.d/04tmpfs ;\
    echo "[precise-amd64-sbuild]" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "type=directory" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "description=Ubuntu precise/amd64 build environment" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "directory=/srv/images/precise-amd64" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "groups=root,sbuild" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "root-groups=root,sbuild" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "profile=sbuild" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "union-type=aufs" >> /etc/schroot/chroot.d/precise-amd64-sbuild ;\
    echo "[trusty-amd64-sbuild]" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "type=directory" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "description=Ubuntu trusty/amd64 build environment" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "directory=/srv/images/trusty-amd64" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "groups=root,sbuild" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "root-groups=root,sbuild" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "profile=sbuild" >> /etc/schroot/chroot.d/trusty-amd64-sbuild ;\
    echo "union-type=aufs" >> /etc/schroot/chroot.d/trusty-amd64-sbuild
