#!/bin/bash
hostname=`/bin/hostname`
week=`date +%w`
datadir=/backup
logdir=/backup/log
mycnf=/etc/my.cnf
Time=`date +%Y-%m-%d_%H-%M-%S`
cmd=`which innobackupex`
user=root
passwd=mysqladmin


function getdir()
{
	if [ ! -d ${datadir} ];then
		mkdir -p ${datadir}
	fi
}
function backup()
{
	if [ ${week} == "0" ];then
		$cmd --defaults-file=${mycnf} --user=${user} --password=${passwd} ${datadir}&>${logdir}/${Time}-log
		[ $? -eq 0 ] && stat=`tail -1 ${logdir}/${Time}-log |awk '{print $4}'`
		if [ "${stat}" == "OK!" ];then
			echo "${Time} mysql backup is success!"
		else
			echo "${Time} mysql backup is fail! please check ${logdir}/${Time}-log"
		fi
	else
		$cmd --defaults-file=${mycnf} --user=${user} --password=${passwd} --incremental --incremental-basedir=${datadir}&>${logdir}/${Time}-log
					
}
