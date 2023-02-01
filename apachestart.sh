#!/bin/sh
set -eux

# Generate self-signed cert
dpkg-reconfigure ssl-cert
# Configure global default hostname
echo "ServerName $(hostname)" >> /etc/apache2/apache2.conf
# Validate config
apachectl configtest
# Launch Apache
apachectl -DFOREGROUND
