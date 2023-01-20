FROM docker.io/library/debian:bullseye-slim

ARG MOD_AUTH_OPENIDC_VERSION=v2.4.12.2
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        apache2 \
        curl \
        libcjose0 \
        libhiredis0.14 && \
    a2dissite 000-default default-ssl && \
    a2disconf charset localized-error-pages serve-cgi-bin && \
    a2dismod -f access_compat auth_basic autoindex deflate filter negotiation status && \
    a2enmod headers include proxy_http proxy_wstunnel remoteip rewrite ssl && \
    curl -Ls "https://api.github.com/repos/zmartzone/mod_auth_openidc/releases/tags/$MOD_AUTH_OPENIDC_VERSION" | \
        grep -o -E "https://(.*).bullseye_amd64.deb" | xargs curl -LO && \
    dpkg -i *.deb && \
    rm -rf *.deb /var/cache/apt /var/lib/apt

COPY apachestart.sh /usr/local/bin

CMD /usr/local/bin/apachestart.sh
