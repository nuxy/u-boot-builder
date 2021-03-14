#!/usr/bin/env bash
#
#  build.sh
#  Create a U-Boot loader for your embedded hardware.
#
#  Copyright 2021, Marc S. Brooks (https://mbrooks.info)
#  Licensed under the MIT license:
#  http://www.opensource.org/licenses/mit-license.php
#
#  Dependencies:
#    docker
#
#  Notes:
#   - This script has been tested to work with Linux
#

# Create containers.
cat << 'EOF' > Dockerfile
FROM ubuntu:18.04

ARG CONFIG="menuconfig"
ARG TOOLCHAIN="arm-linux-gnueabihf-"
ARG VERSION="master"

RUN apt-get update
RUN apt-get install -y bc bison build-essential flex gcc-arm-linux-gnueabihf git libncurses5-dev make pkg-config python3.7-distutils python3-dev qt5-default swig
RUN git clone git://github.com/u-boot/u-boot.git --branch ${VERSION}

WORKDIR /u-boot

ENV CROSS_COMPILE=${TOOLCHAIN}
ENV DEF_CONFIG=${CONFIG}
ENV PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/home/USER/Qt/5.11.2/gcc_64/lib/pkgconfig"
ENV TERM="xterm"

ADD . /output

CMD make distclean ; make ${DEF_CONFIG} && make && cp *.bin /output
EOF

# Run build process.
docker build --build-arg CONFIG=nanopi_neo_defconfig --build-arg VERSION=v2020.04 --tag=das:u-boot .
docker run -it -v "$PWD:/board" --rm das:u-boot

rm Dockerfile
