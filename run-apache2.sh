#!/bin/bash

# See https://github.com/phusion/baseimage-docker#adding_additional_daemons
# https://www.digitalocean.com/community/tutorials/how-to-create-a-ssl-certificate-on-apache-for-ubuntu-14-04

set -e

# TODO: Add to Dockerfile
# ADD xxx /etc/apache2/ssl/apache.pem

# TODO: Should move the preparation to Dockerfile (ADD webproxy.conf)
# Leave only a webproxy.conf.sample on git repo

# TODO: Parse config file "webproxy.conf" in the following format:
#
# KEYWORD    URL
# -------------------------------------
# site       https://github.com/gmacario/maxlab.polito.it.git
# conf       https://raw.githubusercontent.com/gmacario/gm-hostconfig/master/maxlab-webproxy/etc/apache2/sites-available/maxlab
# conf       https://raw.githubusercontent.com/gmacario/gm-hostconfig/master/maxlab-webproxy/etc/apache2/sites-available/maxlab-ssl
# site       https://github.com/SOLARMA/solarma.github.com.git
# conf       https://raw.githubusercontent.com/gmacario/gm-hostconfig/master/maxlab-webproxy/etc/apache2/sites-available/solarma
# -------------------------------------
# KEYWORD: {site | conf}
# URL:     URL where the repo/file can be fetched

a2enmod proxy proxy_http
a2enmod ssl

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
# Configure site "https://maxlab.polito.it/"
if [ ! -e /etc/apache2/sites-available/maxlab-ssl.conf ]; then
    cd /etc/apache2/sites-available
    curl -o maxlab-ssl.conf.ORIG \
        https://raw.githubusercontent.com/gmacario/gm-hostconfig/master/maxlab-webproxy/etc/apache2/sites-available/maxlab-ssl
    awk '
/DocumentRoot/ {print "\tDocumentRoot /var/www/maxlab.polito.it"; next}
/SSLCertificateFile/ {print "\tSSLCertificateFile /etc/apache2/ssl/apache.crt"
        print "\tSSLCertificateKeyFile /etc/apache2/ssl/apache.key"; next}
// {print $0}
' maxlab-ssl.conf.ORIG >maxlab-ssl.conf
    cd /etc/apache2/sites-enabled && ln -sf ../sites-available/maxlab-ssl.conf
fi

# Unconfigure default site
rm -f /etc/apache2/sites-enabled/000-default.conf

source /etc/apache2/envvars
mkdir -p ${APACHE_LOCK_DIR}

exec /usr/sbin/apachectl -D FOREGROUND

# EOF
