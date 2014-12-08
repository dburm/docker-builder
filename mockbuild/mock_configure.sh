#!/bin/bash
DISTPOSTFIX="M"
for cfg in /etc/mock/epel-{6,7}-x86_64.cfg; do
    sed -e "$ i\\\n[extra]\nname=Extra repository\nbaseurl=%EXTRAREPOURL%\nenabled=0" \
        -e "/config_opts\['dist'\]/s/= '\(.*\)'.*$/= '\1.${DISTPOSTFIX}'/" $cfg \
        > `echo $cfg | sed "s/epel/centos/g"`  
done
