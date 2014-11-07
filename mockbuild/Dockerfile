FROM centos:centos7
MAINTAINER dburmistrov@mirantis.com

ENV NAMESERV 172.18.80.136

COPY mock-1.2.0-1.el7.centos.noarch.rpm /

RUN echo "nameserver $NAMESERV" > /etc/resolv.conf ;\
    yum -y install yum-utils sudo ;\
    yum-config-manager --add-repo http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64 ;\
    yum -y install --nogpgcheck /mock-1.2.0-1.el7.centos.noarch.rpm ;\
    rm -f /mock-1.2.0-1.el7.centos.noarch.rpm ;\
    useradd abuild -g mock

COPY centos6.cfg /etc/mock/
COPY centos7.cfg /etc/mock/
