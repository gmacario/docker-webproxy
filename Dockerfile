# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.12

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

## Use baseimage-docker's init system.
#CMD ["/sbin/my_init"]

# ...put your own build instructions here...

# From http://www.kstaken.com/blog/2013/07/06/how-to-run-apache-under-docker/
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y gawk git
#
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# TODO: Add /etc/apache2/sites-available/maxlab
# TODO: Add /etc/apache2/sites-available/maxlab-https

EXPOSE 80

# See https://github.com/phusion/baseimage-docker#adding_additional_daemons
RUN mkdir -p /etc/service/apache2
ADD run-apache2.sh /etc/service/apache2/run
RUN chmod 755 /etc/service/apache2/run

#ENTRYPOINT ["/sbin/my_init"]
#ENTRYPOINT ["/usr/sbin/apache2"]
#CMD ["-D", "FOREGROUND"]
#CMD ["-V"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# EOF
