#!/bin/bash

ffmpeg -y -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device /dev/dri/card0 -i /assets/h264_sample.mp4 -c:v h264_vaapi /assets/output.mp4