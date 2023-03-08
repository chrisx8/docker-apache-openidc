ARG DEBIAN_RELEASE=bullseye
ARG MOD_AUTH_OPENIDC_VERSION=v2.4.12.3

FROM docker.io/library/debian:${DEBIAN_RELEASE}-slim

ARG DEBIAN_RELEASE
ARG MOD_AUTH_OPENIDC_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        apache2 \
        curl \
        libcjose0 \
        libhiredis0.14 && \
    curl -Ls "https://api.github.com/repos/zmartzone/mod_auth_openidc/releases/tags/${MOD_AUTH_OPENIDC_VERSION}" | \
        grep -o -E "https://(.*)/libapache2-mod-auth-openidc_(.*).${DEBIAN_RELEASE}_amd64.deb" | xargs curl -LO && \
    dpkg -i *.deb && \
    a2disconf charset localized-error-pages serve-cgi-bin && \
    a2dismod -f access_compat auth_basic autoindex deflate filter negotiation status && \
    a2dissite 000-default default-ssl && \
    a2enmod auth_openidc headers include proxy_http proxy_wstunnel remoteip rewrite ssl && \
    rm /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key && \
    rm -rf *.deb /var/cache/apt /var/lib/apt

COPY apachestart.sh /usr/local/bin

# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL SIGWINCH

CMD /usr/local/bin/apachestart.sh
