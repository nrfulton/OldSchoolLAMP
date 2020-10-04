# LAMP stack with PHP 5.6 and MySQL 5.7.31.
# See README.md for setup instructions.
FROM ubuntu:20.04

# avoid any prompts during installs.
ARG DEBIAN_FRONTEND=noninteractive

# Install Apache and PHP.

## Grab ppa:ondrej/php, which contains an old version of PHP.
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN apt update -y

## install apache2, php5.6, php-mysql, and other dependencies.
RUN apt install -y \
      apache2 \
      php5.6 \
      php5.6-mysql \ 
      php5.6-mbstring \
      php-mbstring php7.0-mbstring \
      php-xdebug \
      libapache2-mod-php5.6 \
      unzip \
      certbot \
      python3-certbot-apache

# setup apache

## tell apache to use PHP 5.6
RUN update-alternatives --set php /usr/bin/php5.6
RUN ln -sfn /usr/bin/php5.6 /etc/alternatives/php
RUN a2enmod php5.6

## copy config file to apache.
COPY apache2.conf .
RUN mv apache2.conf /etc/apache2/apache2.conf;

# install a much older version of MySQL

## install MySQL Server 5.7.31 from tarball
COPY mysqlserver5.7.tar .
RUN mkdir debs
RUN tar xvf mysqlserver5.7.tar -C debs/
RUN apt -q -y install ./debs/*.deb

## copy over updated myssqld.cnf
COPY mysqld.cnf .
RUN mv mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

## clean up.
RUN rm -rf debs/*
RUN rm mysqlserver5.7.tar

# Copy over the post-install script and run it on startup.

COPY post_install.sh .
RUN chmod +x post_install.sh
