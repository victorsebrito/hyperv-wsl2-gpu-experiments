FROM ubuntu:noble AS runtime

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y

RUN apt install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg

ADD samples /samples
ADD tests /tests

ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib