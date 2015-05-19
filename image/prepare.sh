#!/bin/bash
set -e
source /build/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

export INITRD=no

# Adding oracle JDK from Ubuntu Repositories
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
# Accepting Oracle JDK License
cat <<-EOF | debconf-set-selections
debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
EOF

# Update repos
apt-get update

## Upgrade all packages.
apt-get dist-upgrade -y --no-install-recommends

chmod +x /build/bin/*
chmod +x /build/runit/*
chmod +x /build/*.sh