#!/usr/bin/env bash

set eux

if [[ ! -v BUILD_VERSION ]]; then
    echo "BUILD_VERSION is not set"
    exit 1
fi

sudo docker image rm -f debian-sid-builder

sudo docker build . -t debian-sid-builder
sudo docker run --rm -t \
    -e "BUILD_VERSION=$BUILD_VERSION" \
    -v $PWD:/shared \
    debian-sid-builder
