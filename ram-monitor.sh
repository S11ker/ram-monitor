#!/usr/bin/env bash

LOG_FILE="/var/log/high_memory_usage.log"

TELEGRAM_BOT_TOKEN="YOUR_TOKEN"
TELEGRAM_CHANNEL_CHAT_ID="YOUR_TELEGRAM_CHANNEL_ID"

ALERT_SEC_INTERVAL=300
DAEMON_CHECK_INTERVAL=120

HIGHEST_MEMORY_LOAD_LIMIT=90

# Функция для отправки алерта в Телеграм
SEND_TELEGRAM_ALERT() {
    
    ALL_MEMORY_IN_SERVER=$(free -h | awk 'NR==2{print $2}')

    BUSY_MEMORY_IN_SERVER=$(free -h | awk 'NR==2{print $3}')
    
    HOSTNAME=$(hostname)

    ALERT_MESSAGE="
    		   ALERT: Высокое потребление RAM на сервере $HOSTNAME!
                     
                                 Всего RAM: $ALL_MEMORY_IN_SERVER 
                     
                                 Занято:        $BUSY_MEMORY_IN_SERVER ($1%) 
                                 
                                 Логи в:    			  $LOG_FILE"

    URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
    curl -s -o /dev/null -X POST $URL -d chat_id=$TELEGRAM_CHANNEL_CHAT_ID -d text="$ALERT_MESSAGE"    
}
# --------------------------


while true; do

	MEMORY_USED_IN_PERCENT=$(free -b | awk 'NR==2{print int($3 / $2 * 100)}')

	if [ $MEMORY_USED_IN_PERCENT -ge $HIGHEST_MEMORY_LOAD_LIMIT  ]; then

	SEND_TELEGRAM_ALERT $MEMORY_USED_IN_PERCENT

	# --- Запись в лог файл десяти самых больших процессов
	{
		TIMESTAMP_FOR_LOG_FILE=$(date "+%d-%m-%Y %H:%M:%S")
	        echo "--- $TIMESTAMP_FOR_LOG_FILE ---"

		echo ""
		
	        echo "Top 10 processes by memory usage:"

	        echo ""
		
		TOP_10_MEMORY_USAGE_PROCESSES=$(ps -eo pid,cmd,start,time,command,%mem --sort=-%mem | head -n 10)
	        printf "%b\n" "$TOP_10_MEMORY_USAGE_PROCESSES"

	        echo ""

	} >> "$LOG_FILE"
	sleep $ALERT_SEC_INTERVAL
	# ---
	
	fi
	sleep $DAEMON_CHECK_INTERVAL
done
