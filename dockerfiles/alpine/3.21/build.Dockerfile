FROM alpine:3.21

ARG LLVM_VERSION=17
ARG MESA_VERSION=24.0.9
ARG PREFIX=/usr

# Install build dependencie
RUN apk update && apk add --no-cache \
    alpine-sdk \
    libdrm-dev \
    libxext-dev \
    libxdamage-dev \
    libxcb-dev \
    libxshmfence-dev \
    bison \
    eudev-dev \
    expat-dev \
    findutils \
    flex \
    gettext \
    elfutils-dev \
    glslang-dev \
    libtool \
    libxfixes-dev \
    libva-dev \
    libvdpau-dev \
    libx11-dev \
    libxml2-dev \
    libxrandr-dev \
    libxxf86vm-dev \
    llvm$LLVM_VERSION-dev \
    meson \
    py3-mako \
    py3-packaging \
    python3 \
    vulkan-loader-dev \
    wayland-dev \
    wayland-protocols \
    xorgproto \
    zlib-dev \
    zstd-dev

# Build and install mesa
RUN wget https://archive.mesa3d.org/mesa-$MESA_VERSION.tar.xz && \
    tar xf mesa-$MESA_VERSION.tar.xz
RUN cd mesa-$MESA_VERSION && \
    meson setup build/ \
    -Dprefix=$PREFIX \
    -Dgallium-drivers=d3d12 \
    -Dvulkan-drivers= \
    -Dgallium-va=enabled \
    -Dplatforms= \
    -Dglx=disabled \
    -Degl-native-platform=drm \
    -Dvideo-codecs=all
RUN cd mesa-$MESA_VERSION && \
    ninja -C build/ && \
    ninja -C build/ install && \
    cd .. && \
    rm -rf mesa-$MESA_VERSION mesa-$MESA_VERSION.tar.xz

RUN apk add \
    libva-utils \
    ffmpeg

ENTRYPOINT ["/bin/sh"]