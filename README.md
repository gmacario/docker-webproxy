docker-webproxy
===============

[![PullReview stats](https://www.pullreview.com/github/gmacario/docker-webproxy/badges/master.svg?)](https://www.pullreview.com/github/gmacario/docker-webproxy/reviews/master)

[Docker](http://www.docker.io/) project to deploy an instance
of [Apache](http://www.apache.org/) serving as web proxy
to multiple web applications which are not directly exposed to the Internet.

Copyright 2014-2015, [Gianpaolo Macario](https://github.com/gmacario/)

System Requirements
-------------------

* [Docker](http://www.docker.io) - Tested with v1.3.0
* One OS supported by Docker - Tested with Ubuntu server 14.04.1 (64-bit)

Prerequisites
-------------

1. Create a SSL Certificate for your website.
   You may use the following command to generate a self-signed SSL key:

        $ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout apache.key -out apache.crt

2. Review and/or customize run-apache.sh

Building the Docker image
-------------------------

    $ docker build -t _imagename_ .

Example:

    $ docker build -t gmacario/maxlab-webproxy .

Running the Docker image
------------------------

    $ docker run -d -p 80:80 -p 443:443 -h _svrname_ _imagename_

Example:

    $ docker run -d -p 80:80 -p 443:443 -h maxlab.polito.it gmacario/maxlab-webproxy

Debugging
---------

    $ docker run -t -i -p 80:80 -p 443:443 -h _svrname_ _imagename_ /bin/bash

Then inside the container launch the services manually - i.e.

    /etc/service/apache2/run

A less intrusive way of debugging the container is by using the `docker-enter` command.
See https://github.com/jpetazzo/nsenter for details.

Alternatively you may enable a shell login via SSH:

    $ docker run ... _imagename_ /sbin/my_init --enable-insecure-key

then login via SSH using the private key displayed when the container is started.

<!-- EOF -->
