#!/bin/bash
set -e

# Set required environment variables
source /etc/apache2/envvars

# Create Apache runtime dirs
mkdir -p "$APACHE_LOCK_DIR" "$APACHE_LOG_DIR" "$APACHE_RUN_DIR"
rm -f "$APACHE_RUN_DIR/*ssl_scache*"
chown "$APACHE_RUN_USER" "$APACHE_LOCK_DIR"

# Generate self-signed cert
dpkg-reconfigure ssl-cert
# Configure global default hostname
echo "ServerName $(hostname)" > /etc/apache2/conf-enabled/servername.conf

# Launch Apache
exec /usr/sbin/apache2 -f /etc/apache2/apache2.conf -DFOREGROUND
