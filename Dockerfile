FROM ubuntu:18.04

ARG CONFIG="menuconfig"
ARG TOOLCHAIN="arm-linux-gnueabihf-"
ARG VERSION="master"

RUN apt-get update
RUN apt-get install -y bc bison build-essential flex gcc-arm-linux-gnueabihf git libncurses5-dev make pkg-config python3.7-distutils python3-dev qt5-default swig
RUN git clone git://git.denx.de/u-boot.git --branch ${VERSION}

WORKDIR /u-boot

ENV CROSS_COMPILE=${TOOLCHAIN}
ENV DEF_CONFIG=${CONFIG}
ENV PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/home/USER/Qt/5.11.2/gcc_64/lib/pkgconfig"
ENV TERM="xterm"

ADD . /build

CMD make distclean ; make ${DEF_CONFIG} && make && cp *.bin /board
