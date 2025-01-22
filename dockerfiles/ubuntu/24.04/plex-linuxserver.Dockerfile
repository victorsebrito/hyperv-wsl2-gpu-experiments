# this image is based on ubuntu noble
FROM lscr.io/linuxserver/plex:1.41.3.9314-a0bfb8370-ls251

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y

RUN apt-get install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg

ENTRYPOINT [""]
CMD ["/init"]