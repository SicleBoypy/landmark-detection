#!/usr/bin/env sh
# Example : sh scripts/300W/300W_HG_RMSP.sh 0,1 
echo script name: $0
echo $# arguments
if [ "$#" -ne 4 ] ;then
  echo "Input illegal number of parameters " $#
  echo "Need 4 parameters for gpu devices, detection version, optimizer config version, and the face detector"
  exit 1
fi
gpus=$1
detveon=$2
version=$3
det=$4
batch_size=8
sigma=4
height=96
width=96

CUDA_VISIBLE_DEVICES=${gpus} python ./exps/basic_main.py \
    --train_lists ./cache_data/lists/300W/300w.train.${det} \
    --eval_ilists ./cache_data/lists/300W/300w.test.common.${det} \
                  ./cache_data/lists/300W/300w.test.challenge.${det} \
                  ./cache_data/lists/300W/300w.test.full.${det} \
    --num_pts 68 --data_indicator 300W-68 \
    --model_config ./configs/face/HG.${detveon}.config \
    --opt_config   ./configs/face/RMSP.${version}.config \
    --save_path    ./snapshots/300W-HG-${detveon}-RMSP-${version}-${det} \
    --pre_crop_expand 0.2 \
    --sigma ${sigma} --batch_size ${batch_size} \
    --crop_height ${height} --crop_width ${width} --crop_perturb_max 30 --rotate_max 20 \
    --scale_prob 1.0 --scale_min 0.9 --scale_max 1.1 --scale_eval 1 \
    --print_freq 100 --workers 20 \
    --heatmap_type gaussian