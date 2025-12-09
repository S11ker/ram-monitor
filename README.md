# ram-monitor

_Ram Monitor_ is a systemd daemon that monitors RAM usage percentage and sends an alert to a Telegram channel when the usage reaches 90%.

**Default settings**:
- Checks usage percentage every two minutes
- Five-minute interval between alerts to avoid spamming the channel

These **parameters can be modified** in the **ram-monitor.sh** file in the variables:
`DAEMON_CHECK_INTERVAL=120`
`ALERT_SEC_INTERVAL=300`

**You can** also **change the percentage of abnormal load** that triggers the alert:
`HIGHEST_MEMORY_LOAD_LIMIT=90`

**Main files**:
1. ram-monitor.service → daemon file that uses the main monitoring script
2. ram-monitor.sh      → the monitoring script itself

***‼️ Important ‼️***: Both files contain fields where you must substitute your own values
⬇️
- In ram-monitor.sh:
  - Telegram bot token:
    `TELEGRAM_BOT_TOKEN="YOUR_TOKEN"`
  - Telegram chat ID:
    `TELEGRAM_CHANNEL_CHAT_ID="YOUR_TELEGRAM_CHANNEL_ID"`

- In ram-monitor.service:
  - Path to ram-monitor.sh script:
    `ExecStart="PATH TO .SH SCRIPT"`

Daemon installation recommendations (first ensure the daemon file points to the correct script path):
---
1. ```sudo mv </path/ram-monitor.service> /etc/systemd/system```
2. ```sudo systemctl daemon-reload```
3. ```sudo systemctl enable ram-monitor.service```
4. ```sudo systemctl start ram-monitor.service```
