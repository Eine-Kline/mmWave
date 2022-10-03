image_dir=data/lenacv-camera # 棋盘格图片
save_dir=configs/lenacv-camera # 保存标定结果
width=11
height=14
square_size=15 #mm
image_format=png # 图片格式，如png,jpg
#show=True # 是否显示检测结果
show=True # 是否显示检测结果
# stereo camera calibration
python stereo_camera_calibration.py \
    --left_file $save_dir/left_cam.yml \
    --right_file $save_dir/right_cam.yml \
    --left_prefix left \
    --right_prefix right \
    --width $width \
    --height $height \
    --left_dir $image_dir \
    --right_dir $image_dir \
    --image_format  $image_format  \
    --square_size $square_size \
    --save_dir $save_dir \