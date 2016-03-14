# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Heiko Ziegler <git@z5r.de>


# Install dependencies
RUN     apt-get update && \
        apt-get install -y git-core wget build-essential libxml2-dev liblua5.1-0-dev libesmtp-dev debhelper cdbs pkg-config libssl-dev


# build pthsem
RUN	wget --no-check-certificate https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz && \
	tar xzf pthsem_2.0.8.tar.gz

WORKDIR	pthsem-2.0.8
RUN	dpkg-buildpackage -b -uc
WORKDIR	..
RUN	dpkg -i libpthsem*.deb



# build linknx
ARG     VERSION=0.0.1.32

RUN     wget http://downloads.sourceforge.net/project/linknx/linknx/linknx-$VERSION/linknx-$VERSION.tar.gz && \
        tar -zxvf linknx-$VERSION.tar.gz

WORKDIR linknx-$VERSION

RUN     ./configure --enable-smtp --with-lua --without-pth-test

RUN     make

RUN 	make install

VOLUME  /dist
CMD     if [ -d /dist ]; then cp /libpthsem*.deb /dist; cp /usr/local/bin/linknx /dist; fi


