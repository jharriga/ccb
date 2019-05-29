FROM centos:7
MAINTAINER John Harrigan <jharriga@redhat.com>

ENV COSVERSION="0.4.2.c4"
ENV COSPKGNAME="${COSVERSION}.zip"
ENV COSWGET="https://github.com/intel-cloud/cosbench/releases/download/v${COSVERSION}/${COSPKGNAME}"

RUN yum install -y wget unzip which nmap-ncat java && \
    yum clean all

RUN wget ${COSWGET}

COPY ${COSPKGNAME} /

RUN unzip /${COSPKGNAME} -d / \
    && mv /${COSVERSION} /cosbench \
    && rm -f /${COSPKGNAME} \
    && rm -f /bin/sh && ln -s /bin/bash /bin/sh

ADD start-cosbench.sh /cosbench/

RUN chmod a+x /cosbench/*.sh

CMD ["/cosbench/start-cosbench.sh"]
