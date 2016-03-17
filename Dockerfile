# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Heiko Ziegler <git@z5r.de>


# Install dependencies
RUN     apt-get update && \
        apt-get install -y git-core wget build-essential libxml2-dev liblua5.1-0-dev liblog4cpp5-dev libesmtp-dev debhelper cdbs pkg-config libssl-dev


# build pthsem
RUN	wget --no-check-certificate https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz && \
	tar xzf pthsem_2.0.8.tar.gz

# install pthsem
WORKDIR	pthsem-2.0.8
RUN	dpkg-buildpackage -b -uc
RUN	dpkg -i ../libpthsem*.deb



# build linknx
WORKDIR	/
ARG     VERSION

RUN     wget http://downloads.sourceforge.net/project/linknx/linknx/linknx-$VERSION/linknx-$VERSION.tar.gz && \
        tar -zxvf linknx-$VERSION.tar.gz

WORKDIR linknx-$VERSION

RUN     ./configure --enable-smtp --with-lua --with-log4cpp --with-pth-test 2>&1 >/linknx_configure.log

RUN     make 2>&1 >/linknx_make.log

RUN 	make install


VOLUME  /dist
CMD     if [ -d /dist ]; then cp /libpthsem*.deb /dist; cp /usr/local/bin/linknx /dist; cp /*.log /dist; fi


