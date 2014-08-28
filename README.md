docker-webproxy
===============

[Docker](http://www.docker.io/) project to deploy an instance
of [Apache](http://www.apache.org/) serving as web proxy
to multiple web applications which are not directly exposed to the Internet.

Copyright 2014, [Gianpaolo Macario](https://github.com/gmacario/)

System Requirements
-------------------

* [Docker](http://www.docker.io) - Tested with v1.1.0
* One OS supported by Docker - Tested with Ubuntu server 14.04.1

Building the Docker image
-------------------------

    docker build -t gmacario/webproxy .

Running the Docker image
------------------------

    docker run -d -p 80:80 -h maxlab.polito.it gmacario/webproxy

Debugging
---------

    docker run -t -i -p 80:80 -h maxlab.polito.it gmacario/webproxy /bin/bash

Then launch the services manually - i.e.

    /etc/service/apache2/run

A less intrusive way of debugging the container is by using the `docker-enter` command.
See https://github.com/jpetazzo/nsenter for details.

Alternatively you may enable a shell login via SSH:

    docker run -p 80:80 -h maxlab.polito.it gmacario/webproxy /sbin/my_init --enable-insecure-key

then login via SSH using the private key displayed when the container is started

EOF
