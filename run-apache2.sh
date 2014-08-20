#!/bin/bash

# See https://github.com/phusion/baseimage-docker#adding_additional_daemons

set -e

# TODO: Should move the preparation to Dockerfile

a2enmod proxy proxy_http

# Configure site "http://maxlab.polito.it/"
if [ ! -e /var/www/maxlab.polito.it ]; then
    # Populate website contents
    cd /var/www
    git clone https://github.com/gmacario/maxlab.polito.it.git
    chown -R www-data maxlab.polito.it
fi
if [ ! -e /etc/apache2/sites-available/maxlab.conf ]; then
    cd /etc/apache2/sites-available
    curl https://raw.githubusercontent.com/gmacario/gm-hostconfig/master/mv-linux-powerhorse/etc/apache2/sites-available/maxlab >maxlab.conf.ORIG
    awk '/DocumentRoot/ {print "\tDocumentRoot /var/www/maxlab.polito.it"; next}
// {print $0}
' maxlab.conf.ORIG >maxlab.conf
    cd /etc/apache2/sites-enabled && ln -sf ../sites-available/maxlab.conf
fi

# Unconfigure default site
rm -f /etc/apache2/sites-enabled/000-default.conf

source /etc/apache2/envvars
mkdir -p ${APACHE_LOCK_DIR}

exec /usr/sbin/apachectl -D FOREGROUND

# EOF
