#######################
#### 01 -- Install
#######################
##
cd "2 - DeepTextRecognition"
docker build -t deep-text-recognition .
cd ..


#######################
#### 02 - Create Image
#######################
##
## Windows
docker run --name text_recognition --gpus all  -v "$PWD/2 - DeepTextRecognition:/app/" -v "$PWD/1 - TextRecognitionDataGenerator/out:/app/out/" -it deep-text-recognition bash

## Linux
docker run --name text_recognition --gpus all -v "./2 - DeepTextRecognition":/app/ -v "./1 - TextRecognitionDataGenerator/out":/app/out/ -it deep-text-recognition /bin/bash


#######################
#### 03 - Execute
#######################
##
## Start container if not running
docker start text_recognition

## Execute it
docker exec -it text_recognition bash


#######################
#### 04 - Commands
#######################
##

## Create Labels 
## IMPORTANT: There is no need to create labels.txt if you used "--name_format 2" on the generator
python3 create_labels.py --dir_path ./train

## Create LMDB
### Whenever you generate new images you need to re-create the lmdb
python3 create_lmdb_dataset.py ./out/ ./out/labels.txt ./lmdb_output


### On Train if you use the default variables
### and want to use case-sensitive you can use
### --sensitive

## Train ### --num_iter
### It's advisible to use different validation data
CUDA_VISIBLE_DEVICES=0 CUDA_LAUNCH_BLOCKING=1 python3 train.py --train_data ./lmdb_output --valid_data ./lmdb_output --select_data / --batch_ratio 1 \
    --Transformation None --FeatureExtraction VGG --SequenceModeling BiLSTM --Prediction CTC \
    --character "0123456789-=+\!@#$%&*()[]'\"\,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" \
    --imgH 128 --imgW 200 --num_iter 10000 --valInterval 1000 --data_filtering_off

## TEST
CUDA_VISIBLE_DEVICES=0 CUDA_LAUNCH_BLOCKING=1 python3 train.py --train_data ./lmdb_output --valid_data ./lmdb_output --select_data / --batch_ratio 1 \
    --Transformation TPS --FeatureExtraction ResNet --SequenceModeling BiLSTM --Prediction Attn \
    --character "0123456789-=+\!@#$%&*()[]'\"\,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" \
    --imgH 128 --num_iter 10000 --valInterval 1000 --data_filtering_off

## TEST 2
CUDA_VISIBLE_DEVICES=0 CUDA_LAUNCH_BLOCKING=1 python3 train.py --train_data ./lmdb_output --valid_data ./lmdb_output --select_data / --batch_ratio 1 \
    --Transformation TPS --FeatureExtraction ResNet --SequenceModeling BiLSTM --Prediction CTC \
    --character "0123456789-=+\!@#$%&*()[]'\"\,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" \
    --imgH 128 --num_iter 10000 --valInterval 1000 --data_filtering_off



##  Clear and Recreate Labels
rm ./train/labels.txt
python3 ./code/create_labels.py --dir_path ./train
python3 ./code/create_lmdb_dataset.py ./train/ ./train/labels.txt ./lmdb_output



#### CUDA
https://docs.docker.com/desktop/features/gpu/

docker run --rm -it --gpus=all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark

