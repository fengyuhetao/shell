#!/bin/bash

docker stop lamp_seata
docker rm lamp_seata

docker run -d --restart always --name lamp_seata \
  -p 8091:8091 -p 7091:7091 -v /mydata/seata/config/resources:/seata-server/resources \
  -e SEATA_PORT=8091  -e SEATA_IP=192.168.80.130  seataio/seata-server:1.7.1
