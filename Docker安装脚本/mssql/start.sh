#!/bin/bash
cur_dir=`pwd`


docker stop mssql
docker rm mssql
sudo docker run --name mssql -e 'ACCEPT_EULA=Y' \
  -e 'MSSQL_SA_PASSWORD=1234@abcd' \
  -p 1433:1433 \
  -v /opt/mssql/data:/var/opt/mssql/data \
  -v /opt/mssql/log:/var/opt/mssql/log \
  -v /opt/mssql/secrets:/var/opt/mssql/secrets \
  mcr.microsoft.com/mssql/server:2019-latest
