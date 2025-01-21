FROM lscr.io/linuxserver/plex:1.41.3.9314-a0bfb8370-ls251

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y

RUN apt install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg