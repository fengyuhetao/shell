#!/bin/bash
mysql_user='root'
mysql_pass="bhVd!564qazWSX78U#7"
data=$(/bin/date +%Y-%m-%d-%H:%M)
/bin/netstat -lntup|egrep ":3306"|grep -v grep>/dev/null0
if [ $? -eq 0 ];then
	Slave_IO=`/data/mysql/bin/mysql -u${mysql_user} -p${mysql_pass} -e "show slave status\G"|grep "Slave_IO_Running:"|awk -F": " '{print $2}'`
	Slave_SQL=`/data/mysql/bin/mysql -u${mysql_user} -p${mysql_pass} -e "show slave status\G"|grep "Slave_SQL_Running:"|awk -F": " '{print $2}'`
		if [ "$Slave_IO" == "Yes" ] && [ "$Slave_SQL" == "Yes" ];then
			STAT=1 && echo "$data mysql-status is ok">>/var/log/mysql-status.log
		else
			STAT=0 && echo "$data mysql-status is error">>/var/log/mysql-status.log
		fi
else
	STAT=0 && echo "$data mysql-status is error">>/var/log/mysql-status.log
fi
/usr/bin/zabbix_sender -z 101.227.67.205 -s "DaoDaEr-mysql-status" -k mysql -o $STAT
