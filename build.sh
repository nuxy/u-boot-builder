#!/usr/bin/env bash
#
#  build.sh
#  Create a U-Boot loader for your ARM embedded hardware.
#
#  Copyright 2021, Marc S. Brooks (https://mbrooks.info)
#  Licensed under the MIT license:
#  http://www.opensource.org/licenses/mit-license.php
#
#  Dependencies:
#    docker
#

release="master"
aarch=32

#
# Parse script arguments.
#
argc=$@
argv=0

for value in $argc; do
    case $argv in
        '--config')
            config=$value
            ;;
        '--platform')
            platform=$value
            ;;
        '--release')
            release=$value
            ;;
        '--aarch')
            aarch=$value
            ;;
    esac

    argv=$value
done

if [[ -z "$config" ]]; then
    cat <<EOT
Usage: build.sh [--config=] [--platform=] [--release=] [--aarch=64]
Options:
  --config   : Board configuration name (e.g. <board_name>_defconfig or menuconfig)
  --platform : Board platform name (optional, to build Arm Trusted Firmware)
  --release  : U-Boot release tag (optional)
  --aarch    : Compile SoC architecture (32/64, default: 32)
EOT
  exit 1
fi

#
# Set platform defaults.
#
BUILD_TAG="das:u-boot"

if [[ $aarch -eq 64 ]]; then
    BUILD_ARGS=" --build-arg TOOLCHAIN=aarch64-linux-gnu-"
else
    BUILD_ARGS=" --build-arg TOOLCHAIN=arm-linux-gnueabihf-"
fi

#
# Build Arm Trusted Firmware
#
if [[ -n "$platform" ]]; then
    cat << 'EOF' > Dockerfile
FROM ubuntu:18.04

ARG PLATFORM
ARG TOOLCHAIN

RUN apt-get update
RUN apt-get install -y build-essential gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf git
RUN git clone git://github.com/ARM-software/arm-trusted-firmware.git

WORKDIR /arm-trusted-firmware

ENV CROSS_COMPILE=${TOOLCHAIN}
ENV PLAT=${PLATFORM}

ADD . /output

CMD make bl31 && find . -name bl31.bin | xargs cp -t /output
EOF

    BUILD_ARGS+=" --build-arg PLATFORM=$platform"

    # Create firmware binary; output to CWD
    docker build $BUILD_ARGS --tag=$BUILD_TAG .
    docker run -it -v "$PWD:/output" --rm $BUILD_TAG
fi

#
# Build "Das U-Boot" loader
#
cat << 'EOF' > Dockerfile
FROM ubuntu:18.04

ARG CONFIG
ARG VERSION
ARG TOOLCHAIN

RUN apt-get update
RUN apt-get install -y bc bison build-essential flex gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf git libncurses5-dev make pkg-config python3.7-distutils python3-dev python3-pkg-resources qt5-default swig
RUN git clone git://github.com/u-boot/u-boot.git --branch ${VERSION}

WORKDIR /u-boot

ENV CROSS_COMPILE=${TOOLCHAIN}
ENV DEF_CONFIG=${CONFIG}
ENV PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/home/USER/Qt/5.11.2/gcc_64/lib/pkgconfig"
ENV BL31="/output/bl31.bin"
ENV TERM="xterm"

ADD . /output

CMD make ${DEF_CONFIG} && make && cp u-boot* /output && rm -f /output/bl31.bin
EOF

BUILD_ARGS+=" --build-arg CONFIG=$config --build-arg VERSION=$release"

# Launch interactive set-up; output to CWD
docker build $BUILD_ARGS --tag=$BUILD_TAG .
docker run -it -v "$PWD:/output" -v /tmp/.X11-unix:/tmp/.X11-unix --rm $BUILD_TAG

#
# Cleanup temporary files
#
rm Dockerfile
