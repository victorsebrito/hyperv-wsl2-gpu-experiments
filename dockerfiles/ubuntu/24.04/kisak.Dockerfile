FROM ubuntu:noble AS runtime

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:kisak/kisak-mesa && apt-get update

RUN apt-get install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg