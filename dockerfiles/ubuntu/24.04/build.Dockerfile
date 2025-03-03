FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive
ARG MESA_VERSION=24.2.8
ARG REVISION=1ubuntu1~24.04.1
ARG PREFIX=/usr

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        devscripts \
        equivs

RUN dget -ux https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/mesa/$MESA_VERSION-$REVISION/mesa_$MESA_VERSION-$REVISION.dsc
WORKDIR /mesa-$MESA_VERSION
RUN mk-build-deps -i -t 'apt-get -y -o Debug::pkgProblemResolver=yes --no-install-recommends'
RUN meson setup build/ \
        -Dprefix=$PREFIX \
        -Dgallium-drivers=d3d12 \
        -Dvulkan-drivers= \
        -Dgallium-va=enabled \
        -Dplatforms= \
        -Dglx=disabled \
        -Degl-native-platform=drm \
        -Dvideo-codecs=all \
        -Dbuildtype=debug
RUN ninja -C build/ && \
    ninja -C build/ install

WORKDIR /
RUN apt-get install -y \
        vainfo \
        ffmpeg