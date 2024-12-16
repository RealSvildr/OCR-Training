#######################
#### 01 -- Install
#######################
##
cd "1 - TextRecognitionDataGenerator"
docker build -t text-recognition-data-generator .
cd ..


#######################
#### 02 - Create Image
#######################
##
## Windows
docker run --name text_generator --gpus all -v "$PWD/1 - TextRecognitionDataGenerator:/app/" -it text-recognition-data-generator bash

## Linux
docker run --gpus all -v "./1 - TextRecognitionDataGenerator":/app/ -it text-recognition-data-generator /bin/bash


#######################
#### 03 - Execute
#######################
##
## Start container if not running
docker start text_generator

## Execute it
docker exec -it text_generator bash


#######################
#### 04 - Create Images
#######################
##
trdg -c 50000 -w 5 -f 64 --font_dir ./fonts/latin/ --dict ./dicts/en-complete.txt --name_format 2

trdg -c 100000 -w 25 -f 128 --margins 30 --font_dir ./fonts/latin/ --dict ./dicts/list-characters.txt --name_format 2

trdg -c 10 -w 5 -f 40 -b 1 --font_dir ./fonts/latin/ --dict ./dicts/list-characters.txt --name_format 2
