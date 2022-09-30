#!/usr/bin/env bash

width=11
height=14
left_video=1
right_video=-1
save_dir="data/camera"
#detect=True

python get_stereo_images.py \
    --left_video $left_video \
    --right_video $right_video \
    --width $width  \
    --height $height  \
    --save_dir $save_dir \
    --detect $detect \