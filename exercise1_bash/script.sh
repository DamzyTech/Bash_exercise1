#!/bin/bash
# Configuration

LOG_FILE = "/var/log/memory_usage.log"
EMAIL_ADDRESS = "kaydamzy2024@gmail.com"
TEMP_FILE = "/tmp/memory_usage_temp.log"

# Function to log memory usage
log_memory() {
    # Get current timestamp
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Get memory info using free command
    MEMORY=$(free -h | awk '/^Mem:/ {print "Total: "$2" Used: "$3" Free: "$4}')
    
    # Append to log file
    echo "[$TIMESTAMP] $MEMORY" >> "$LOG_FILE"
}

# Function to send email and reset log
send_and_reset() {
    # Check if log file exists and has content
    if [ -s "$LOG_FILE" ]; then
        # Send email with log file contents
        mail -s "Daily Memory Usage Report - $(date '+%Y-%m-%d')" "$EMAIL_ADDRESS" < "$LOG_FILE"
        
        # Clear the log file for the new day
        : > "$LOG_FILE"
    fi
}

# Main execution
# Check if it's midnight (00:00)
if [ "$(date '+%H:%M')" = "00:00" ]; then
    send_and_reset
fi

# Log memory usage
log_memory