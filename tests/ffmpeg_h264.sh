#!/bin/bash

ffmpeg -y -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device /dev/dri/card0 \
    -i /samples/h264.mp4 -c:v h264_vaapi /output/h264.mp4