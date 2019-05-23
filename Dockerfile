FROM centos:7
MAINTAINER John Harrigan <jharriga@redhat.com>

ENV COSVERSION="0.4.2.c4"
ENV COSPKGNAME="${COSVERSION}.zip"

RUN yum install -y unzip which nmap-ncat java && \
    yum clean all

COPY ${COSPKGNAME} /

RUN unzip /${COSPKGNAME} -d / \
    && mv /${COSVERSION} /cosbench \
    && rm -f /${COSPKGNAME} \
    && rm -f /bin/sh && ln -s /bin/bash /bin/sh

ADD start-cosbench.sh /cosbench/

RUN chmod a+x /cosbench/*.sh

CMD ["/cosbench/start-cosbench.sh"]
