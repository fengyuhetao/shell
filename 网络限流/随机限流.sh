#!/bin/bash

# 日志文件路径
#LOG_FILE="/path/to/log_file.log"

# 要限速的端口
TARGET_PORT="9090"
# 计数器变量
counter=10
CONDIATION_NUMBER=11
EXECUTE_NUMBER=3
# 函数：设置流量限速
setup_traffic_limit() {
    # 监听特定端口的TCP连接，并动态应用流量限制
    echo "开始执行限流函数"
    tcpdump -i ens33 "tcp[tcpflags] & (tcp-syn) != 0 and port $TARGET_PORT" -n -l |
    while read -r line; do
        # 生成随机数（0到100之间的随机数）
        RANDOM_NUMBER=$((RANDOM % 100))
        EXECUTE_NUMBER=$((RANDOM % 1000))
        # 如果计数器小于阈值，则递增计数器，不执行限流的逻辑
            if [ "$counter" -lt $CONDIATION_NUMBER ]; then
                echo "延迟等待，当前计数器为： $counter 阈值为： $CONDIATION_NUMBER"
                ((counter++))
            else
                # 如果随机数小于85（假设85%的概率），则执行限速
                if [ "$RANDOM_NUMBER" -lt 85 ]; then
                    # 在日志文件中记录限速已启用
                    #echo "$(date): Traffic limit is enabled for port $TARGET_PORT." >> "$LOG_FILE"
                    # 在这里执行设置流量限速的操作，可以调用之前示例中的流量限速设置部分
                    # Your traffic shaping commands here...
                    SRC_IP=$(echo "$line" | awk '{print $3}' | cut -d. -f1-4) # 提取源IP
                    SRC_PORT=$(echo "$line" | awk '{print $3}' | cut -d. -f5) # 提取源端口
                    # 动态应用流量限制
                    tc qdisc add dev ens33 root handle 1: htb default 12
                    #主类别最大限制mbit/kbit
                    tc class add dev ens33 parent 1: classid 1:1 htb rate 200kbit burst 15k
                    #子类别最小和最大限制
                    tc class add dev ens33 parent 1:1 classid 1:12 htb rate 20kbit ceil 100kbit burst 15k
                    iptables -A OUTPUT -p tcp --sport $SRC_PORT -j MARK --set-mark 1

                    echo "生成的随机数为：$RANDOM_NUMBER 限流成功，计数器为： $counter 阈值为：$CONDIATION_NUMBER 加权值为：$EXECUTE_NUMBER"
                    #小于15的时候解除限流
                    if [ "$RANDOM_NUMBER" -lt 15 ] && [ "$((EXECUTE_NUMBER % 6))" -eq 0 ]; then
                        CONDIATION_NUMBER=$(((RANDOM % 50)+1))
                        echo "重新生成延迟等待计数器阈值： $CONDIATION_NUMBER"
                        clear_traffic_limit
                    fi 
                #else
                    # 在日志文件中记录未应用限速
                    #echo "$(date): No traffic limit is applied for port $TARGET_PORT." >> "$LOG_FILE"
                fi
            fi
    done
}

# 函数：清除流量限速设置
clear_traffic_limit() {
    # 在成功清除限速后，将计数器重置为0
    counter=0
    echo "执行清除限流的操作，客户端目标IP：$SRC_IP $SRC_PORT"
    iptables -D OUTPUT -p tcp --sport $TARGET_PORT -j MARK --set-mark 1
    ip rule del fwmark 1 table 1
    tc qdisc del dev ens33 root
    echo "Traffic limit for src port $TARGET_PORT is enabled for this connection."
}


clear_traffic_limit # 确保 clear_traffic_limit 在 setup_traffic_limit 之前调用

setup_traffic_limit # 调用设置流量限速的函数
