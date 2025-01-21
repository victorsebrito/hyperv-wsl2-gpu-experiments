FROM ubuntu:jammy AS runtime

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y

RUN apt install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg