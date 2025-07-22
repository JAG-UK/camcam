#!/bin/bash

# Stream Options - fill in with your own settings
CAMERA_DEVICE=/dev/video0
VIDEO_SIZE=1280x720
STREAM_SECRET=YourSecretGoesHere

# Now stream
ffmpeg -f v4l2 -framerate 30 -video_size $VIDEO_SIZE -i $CAMERA_DEVICE -c:v h264_v4l2m2m -b:v 1M -maxrate 1M -bufsize 2M -tune zerolatency -g 60 -f flv rtmp://camcam.cityrc.co.uk/stream/$STREAM_SECRET
