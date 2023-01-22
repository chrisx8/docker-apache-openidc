#!/bin/sh
set -eux

dpkg-reconfigure ssl-cert
apachectl configtest
apachectl -DFOREGROUND
