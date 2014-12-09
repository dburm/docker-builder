#!/bin/bash
DISTPOSTFIX="M"
for cfg in /etc/mock/epel-{6,7}-x86_64.cfg; do
    DIST=$(grep "config_opts\['dist'\]" $cfg | awk -F"'" '{print $4}')
    sed -e "$ i\\\n[extra]\nname=Extra repository\nbaseurl=%EXTRAREPOURL%\ngpgcheck=0\nenabled=0" \
        -e "/config_opts\['dist'\]/s/$/\nconfig_opts['macros']['%dist'] = '.${DIST}.${DISTPOSTFIX}'/" $cfg \
        > `echo $cfg | sed "s/epel/centos/g"`  
done
