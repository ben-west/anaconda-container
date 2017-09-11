#!/bin/bash

## Disable the VPN before running on Wndows!
# change to script directory
cd $(dirname $(readlink -f $0))
# create a new default docker machine with better options
# don't do this every time, just on first use
#docker-machine stop default
#docker-machine create --driver virtualbox --engine-insecure-registry http://localhost:8000 default
#docker-machine stop default
#'/c/Program Files/Oracle/VirtualBox/VBoxManage.exe' sharedfolder add default --name src --hostpath 'D:\' --automount

docker-machine start default
# setup docker machine env variables
eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env default)

# Build the container from source
docker build -t hodac/anaconda3 .
start http://$(docker-machine ip default):8888

# Start the container with the host D:/ drive mapped to /src in the guest and ~/work in the container#
# Don't require a token to login, though it's pretty insecure.
docker run --rm -it  -p 8888:8888 -v /src/:/home/jovyan/work hodac/anaconda3 jupyter notebook --NotebookApp.token='' --allow-root
