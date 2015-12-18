FROM centos:centos7
# Authors: Dmitry Burmistrov <dburmistrov@mirantis.com>
MAINTAINER Dmitry Burmistrov <dburmistrov@mirantis.com>


RUN yum -y --disableplugin=fastestmirror install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
    yum -y --disableplugin=fastestmirror install mock && \
    yum clean all && \
    useradd abuild -g mock
