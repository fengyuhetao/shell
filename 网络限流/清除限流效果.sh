#!/bin/bash

# 日志文件路径
#LOG_FILE="/path/to/log_file.log"

# 要限速的端口
TARGET_PORT="9090"

# 函数：清除流量限速设置
clear_traffic_limit() {
    echo "执行清除限流的操作"
    # 在日志文件中记录限速已清除
    #echo "$(date): Traffic limit is cleared for port $TARGET_PORT." >> "$LOG_FILE"
    # 在这里执行清除流量限速设置的操作
    iptables -D OUTPUT -p tcp --sport $TARGET_PORT -j MARK --set-mark 1
    ip rule del fwmark 1 table 1
    tc qdisc del dev eth0 root
    echo "Traffic limit for src port $TARGET_PORT is enabled for this connection."
}


clear_traffic_limit

#停止限流的进程
pkill -f traffic.sh