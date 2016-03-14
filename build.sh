#! /bin/bash

# version to build
VERSION=0.0.1.32

# host dir to copy result to
DIST_DIR=dist-$VERSION
IMAGE_NAME=heziegl/rpi-linknx-build:$VERSION

mkdir -p $DIST_DIR

# build linknx
echo building docker image ...
sudo docker build --build-arg VERSION=$VERSION -t $IMAGE_NAME .

# copy dist from container to docker host
echo copying results to $DIST_DIR ...
sudo docker run --rm=true -v $(pwd)/$DIST_DIR:/dist $IMAGE_NAME

