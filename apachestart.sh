#!/bin/sh
set -eux

apachectl configtest
apachectl -DFOREGROUND
