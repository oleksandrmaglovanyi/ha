#!/bin/bash
export APP_NAME=echo-server
sudo yum update -y
sudo yum install docker git -y
sudo systemctl start docker
docker build https://github.com/oleksandrmaglovanyi/ha.git#main:$APP_NAME -t $APP_NAME:latest
docker run -dp 80:3246 $APP_NAME:latest
