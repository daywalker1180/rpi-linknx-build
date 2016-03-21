# Pull base image
FROM resin/rpi-raspbian:wheezy
MAINTAINER Heiko Ziegler <git@z5r.de>


# Install dependencies
RUN     apt-get update && \
        apt-get install -y git-core wget unzip build-essential libxml2-dev liblua5.1-0-dev liblog4cpp5-dev libesmtp-dev debhelper cdbs pkg-config libssl-dev


# build and install pthsem
RUN	wget --no-check-certificate https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz && \
	tar xzf pthsem_2.0.8.tar.gz && \
	cd pthsem-2.0.8 && \
	dpkg-buildpackage -b -uc && \
	dpkg -i ../libpthsem*.deb



# download linknx sources
ARG     VERSION
RUN	if [ $VERSION \> "0.0.1.32" ]; \
	then \
	        wget --no-check-certificate https://github.com/linknx/linknx/archive/v$VERSION.zip && \
	        unzip v$VERSION.zip; \
	else \
		wget http://downloads.sourceforge.net/project/linknx/linknx/linknx-$VERSION/linknx-$VERSION.tar.gz && \
	        tar -zxvf linknx-$VERSION.tar.gz; \
	fi;


# build linknx
WORKDIR linknx-$VERSION
RUN     ./configure --enable-smtp --with-lua --with-log4cpp --with-pth-test && \
	make && \
	make install



# copy results out of the container
VOLUME  /dist
CMD     if [ -d /dist ]; then cp /libpthsem*.deb /dist; cp /usr/local/bin/linknx /dist; fi

