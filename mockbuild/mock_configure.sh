#!/bin/bash
[ -z "$DISTSUFFIX" ] && DISTSUFFIX="M"
for cfg in /etc/mock/epel-{6,7}-x86_64.cfg; do
    DIST=$(grep "config_opts\['dist'\]" $cfg | awk -F"'" '{print $4}')
    sed -e "/config_opts\['dist'\]/s/$/\nconfig_opts['macros']['%dist'] = '.${DIST}.${DISTSUFFIX}'/" $cfg \
        > `echo $cfg | sed "s/epel/centos/g"`  
done
