FROM ubuntu:noble AS runtime

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y

RUN apt-get install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg