#!/bin/bash

# See https://github.com/phusion/baseimage-docker#adding_additional_daemons

set -e

# TODO: Should move the preparation to Dockerfile

a2enmod proxy proxy_http

# Populate/update contents for site "http://maxlab.polito.it/"
cd /var/www && if [ ! -e /var/www/maxlab.polito.it ]; then
    git clone https://github.com/gmacario/maxlab.polito.it.git
    chown -R www-data maxlab.polito.it
else
    cd maxlab.polito.it && git pull --all && cd -
    chown -R www-data maxlab.polito.it
fi
# Configure site "http://maxlab.polito.it/"
if [ ! -e /etc/apache2/sites-available/maxlab.conf ]; then
    cd /etc/apache2/sites-available
    curl -o maxlab.conf.ORIG \
        https://raw.githubusercontent.com/gmacario/gm-hostconfig/master/maxlab-webproxy/etc/apache2/sites-available/maxlab
    awk '
/DocumentRoot/ {print "\tDocumentRoot /var/www/maxlab.polito.it"; next}
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
