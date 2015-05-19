#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install nginx
$minimal_apt_get_install nginx-full
mkdir /etc/service/nginx
cp /build/runit/nginx /etc/service/nginx/run

## Installing Nominatim requirements
$minimal_apt_get_install \
	build-essential libxml2-dev libgeos-dev libpq-dev libbz2-dev libtool automake libproj-dev \
	libboost-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev \
	gcc proj-bin libgeos-c1 osmosis libgeos++-dev \
	php5-fpm php5 php-pear php5-pgsql php5-json php-db \
	postgresql-client-${PG_MAJOR} postgresql-server-dev-${PG_MAJOR} \
	libprotobuf-c0-dev protobuf-c-compiler

## Downloading and extracting Nominatim
groupadd nominatim && useradd -g nominatim nominatim -d /home/nominatim
mkdir /home/nominatim
chown nominatim:nominatim /home/nominatim
curl -O -SL "http://www.nominatim.org/release/Nominatim-${NOMINATIM_VERSION}.tar.bz2"
gosu nominatim tar -xvjf Nominatim-${NOMINATIM_VERSION}.tar.bz2 -C /home/nominatim
rm Nominatim-${NOMINATIM_VERSION}.tar.bz2

## Compiling Nominatim
cd /home/nominatim/Nominatim-${NOMINATIM_VERSION}
gosu nominatim ./configure
gosu nominatim make
cd $HOME

## Installing osmconverter, osmupdate and osmfilter
$minimal_apt_get_install wget osmctools

## Copy the binaries
cp /build/bin/* /usr/bin/