#!/usr/bin/env bash

sudo docker image rm debian-sid-builder

sudo docker build . -t debian-sid-builder
sudo docker run --rm -t -v $PWD:/shared debian-sid-builder
