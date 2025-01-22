# this image is based on ubuntu jammy
FROM lscr.io/linuxserver/plex:1.40.4.8679-424562606-ls225

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y

RUN apt-get install -y \
    vainfo \
    mesa-va-drivers \
    ffmpeg

ENTRYPOINT [""]
CMD ["/init"]