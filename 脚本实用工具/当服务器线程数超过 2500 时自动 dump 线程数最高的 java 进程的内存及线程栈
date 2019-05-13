#!/usr/bin/env bash
# 来源: https://blog.csdn.net/qianghaohao/article/details/80379118 
# 服务器线程数达到 2500 以上时 dump 线程数最多的 java 进程的线程及内存
#
source ~/.bashrc
cur_thread_num=`ps -efL | wc -l`
if [ $cur_thread_num -le 2500 ]; then
    exit 0
fi

cur_date=`date +"%Y-%m-%d_%H-%M-%S"`
cd ./dumpfile
# 服务器当前线程 dump 到文件:按照线程数由大到小排序显示
ps -efL --sort -nlwp > server_thread_dump_$cur_date
# dump 线程数最多的 jvm 的线程及内存
most_thread_num_pid=`cat server_thread_dump_$cur_date | sed -n '2p' | awk '{print $2}'`
nohup jstack -l $most_thread_num_pid > java_app_thread_dump_${cur_date}_pid_${most_thread_num_pid} &
nohup jmap -dump:format=b,file=java_app_mem_dump_${cur_date}_pid_${most_thread_num_pid} $most_thread_num_pid &

exit 0
