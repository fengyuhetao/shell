#!/bin/bash
cur_dir=`pwd`

docker stop lamp_minio
docker rm lamp_minio
docker run -p 9000:9000 -p 9999:9999 --name lamp_minio --restart=always \
  -e "MINIO_ROOT_USER=lamp" \
  -e "MINIO_ROOT_PASSWORD=ZHadmin123." \
  -v /Users/tangyh/data/minio_data:/data \
  -v /Users/tangyh/data/minio_config:/root/.minio \
  -d minio/minio server --address '0.0.0.0:9000' --console-address '0.0.0.0:9999' /data
