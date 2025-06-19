#!/bin/bash

# Configuration
LOG_DIR="/var/log/memory_logger"
LOG_FILE="$LOG_DIR/memory_usage_$(date +%F).log"
EMAIL="kaydamzy2024@gmail.com"

# Create log directory if it doesn't exist
sudo mkdir -p "$LOG_DIR"

# Log memory usage
echo "----- $(date '+%Y-%m-%d %H:%M:%S') -----" >> "$LOG_FILE"
free -h >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# If it's midnight, email and rotate log
if [ "$(date +%H)" == "00" ]; then
    SUBJECT="Daily Memory Usage Report - $(date -d 'yesterday' +%F)"
    MAIL_FILE="$LOG_DIR/memory_usage_$(date -d 'yesterday' +%F).log"

    # Send email
    if [ -f "$MAIL_FILE" ]; then
        mail -s "$SUBJECT" "$EMAIL" < "$MAIL_FILE"
        rm -f "$MAIL_FILE"
    fi
fi