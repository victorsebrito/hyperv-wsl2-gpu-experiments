FROM ubuntu:jammy AS runtime

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y

# Uncomment the lines below to use a 3rd party repository
# to get the latest (unstable from mesa/main) mesa library version
# RUN apt-get update && apt install -y software-properties-common
# RUN add-apt-repository ppa:oibaf/graphics-drivers -y

RUN apt install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg

ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib
COPY test.sh /test.sh