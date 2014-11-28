FROM centos:centos7
MAINTAINER dburmistrov@mirantis.com

ENV NAMESERV 172.18.80.136
#ENV EL7MIRROR http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64
ENV EL7MIRROR http://mirror.logol.ru/epel/7/x86_64/

COPY mock-1.2.2-1.el7.noarch.rpm /

RUN echo "nameserver $NAMESERV" > /etc/resolv.conf ;\
    yum -y install yum-utils sudo ;\
    yum-config-manager --add-repo $EL7MIRROR ;\
    yum -y install --nogpgcheck /mock-1.2.2-1.el7.noarch.rpm ;\
    rm -f /mock-1.2.2-1.el7.noarch.rpm ;\
    useradd abuild -g mock

COPY centos6.cfg /etc/mock/
COPY centos7.cfg /etc/mock/
