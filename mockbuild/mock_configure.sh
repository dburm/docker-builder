#!/bin/bash
for cfg in /etc/mock/epel-{6,7}-x86_64.cfg; do
    sed "$ i\\\n[extra]\nname=Extra repository\nbaseurl=%EXTRAREPOURL%\nenabled=0" $cfg \
        > `echo $cfg | sed "s/epel/centos/g"`  
done
