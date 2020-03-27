FROM debian

RUN sed -n 's/^deb /deb-src /pg' /etc/apt/sources.list  >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y jq devscripts

COPY reverse-deb-git.sh /
RUN chmod a+x /reverse-deb-git.sh
ENTRYPOINT [ "/reverse-deb-git.sh" ]

WORKDIR /tmp
USER nobody
