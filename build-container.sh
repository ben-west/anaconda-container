#!/bin/bash

# change to script directory
cd $(dirname $(readlink -f $0))
# create a new default docker machine with better options
# don't do this every time, just on first use
if ! docker-machine ls | grep hodac-ds; then
    docker-machine create --driver virtualbox --engine-insecure-registry http://localhost:8000 hodac-ds
    docker-machine stop hodac-ds
    '/c/Program Files/Oracle/VirtualBox/VBoxManage.exe' sharedfolder add hodac-ds --name src --hostpath 'D:\' --automount
    docker-machine start hodac-ds
fi
# setup docker machine env variables
eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env hodac-ds)

# Build the container from source
docker build -t hodac/anaconda3 .
start http://$(docker-machine ip hodac-ds):8888
docker run --rm -it  -p 8888:8888 -v /src/:/Data hodac/anaconda3
