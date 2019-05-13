#!/bin/bash
#mail xuel@51idc.com
#data 2017/2/23

#function: use iptables Brute force
SCAN=`/bin/egrep "Failed password for root" /var/log/secure|awk -F'[ :]+' '{print $13}'|sort|uniq -c|awk '{print $1"="$2;}'`
for I in ${SCAN}
do 
	SCANUM=`echo ${I}|awk -F'=' '{print $1}'`
	SCANIP=`echo ${I}|awk -F'=' '{print $2}'`
	if [ ${SCANUM} -gt 100 ] && [ -z "`/sbin/iptables -vnL INPUT | grep $SCANIP`" ];then
		/sbin/iptables -I INPUT -s $SCANIP -m state --state NEW,RELATED,ESTABLISHED -j DROP 
		echo "`date` $SCANIP($SCANUM)">>/var/log/scanIP.log
	fi
done
if [ $? -eq 0 ];then
service iptables save && service iptables restart
fi

