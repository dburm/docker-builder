#!/bin/bash
. $(dirname $(readlink -f $0))/config
CONTAINERNAME=sbuild:latest
CACHEPATH=/var/cache/docker-builder/sbuild
[ -z "$DIST" ] && DIST=trusty

if [ -n "$EXTRAREPO" ] ; then
    EXTRACMD=""
    OLDIFS="$IFS"
    IFS='|'
    for repo in $EXTRAREPO; do
      IFS="$OLDIFS"
      EXTRACMD="${EXTRACMD} --chroot-setup-commands=\"apt-add-repo deb $repo\" "
      IFS='|'
    done
    IFS="$OLDIFS"
fi

if [ `find . -maxdepth 1 -name \*.dsc | wc -l` == 1 ]; then
    SOURCEFILE=`find . -maxdepth 1 -name \*.dsc`
    SOURCEFILE=`basename $SOURCEFILE`
elif [ -e "`pwd`/debian/changelog" ]; then
    unset SOURCEFILE
fi

SOURCEPATH=`pwd`
[ -z "$SOURCEPATH" ] && exit 1

docker run ${DNSPARAM} -i -t --privileged --rm -v ${CACHEPATH}:/srv/images:ro \
    -v ${SOURCEPATH}:/srv/source ${CONTAINERNAME} \
    bash -c "( DEB_BUILD_OPTIONS=nocheck /usr/bin/sbuild -d ${DIST} --nolog \
             --source --force-orig-source \
             $EXTRACMD \
             --chroot-setup-commands=\"apt-get update\" \
             /srv/source/${SOURCEFILE} 2>&1; \
             echo \$? > /srv/build/exitstatus.sbuild ) \
             | tee /srv/build/buildlog.sbuild ;\
             rm -rf /srv/source/buildresult ;\
             mv /srv/build /srv/source/buildresult ;\
             chown -R `id -u`:`id -g` /srv/source"
