#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install nginx
$minimal_apt_get_install nginx-full
mkdir /etc/service/nginx
cp /build/runit/nginx /etc/service/nginx/run

# Creating websites
cp /build/config/nginx/sites-available/* /etc/nginx/sites-available/

## Installing Nominatim requirements
$minimal_apt_get_install \
	build-essential libxml2-dev libgeos-dev libpq-dev libbz2-dev libtool automake libproj-dev \
	libboost-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev \
	gcc proj-bin libgeos-c1 libgeos++-dev \
	php5-fpm php5 php-pear php5-pgsql php5-json php-db \
	postgresql-client-${POSTGRES_VERSION} postgresql-server-dev-${POSTGRES_VERSION} \
	libprotobuf-c0-dev protobuf-c-compiler

# Creating nominatim user
groupadd nominatim && useradd -g nominatim nominatim
mkdir /var/nominatim

## Downloading and extracting Nominatim
curl -O -SL "http://www.nominatim.org/release/Nominatim-${NOMINATIM_VERSION}.tar.bz2"
tar -xvjf Nominatim-${NOMINATIM_VERSION}.tar.bz2 && rm Nominatim-${NOMINATIM_VERSION}.tar.bz2
mv Nominatim-${NOMINATIM_VERSION} /var/nominatim && chown -R nominatim:nominatim /var/nominatim

## Compiling Nominatim
cd /var/nominatim
gosu nominatim ./configure
gosu nominatim make
cd $HOME

## Installing osmconverter, osmupdate and osmfilter
$minimal_apt_get_install wget osmctools

## Copy the binaries
cp /build/bin/* /usr/local/bin/