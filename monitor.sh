#!/bin/bash
# monitor.sh - Periodic Health Check Logger

PRODUCTION_ROOT="$HOME/local-production"
ACTIVE_FILE="$PRODUCTION_ROOT/active_env.txt"
LOG_FILE="health.log"

echo "Starting Application Monitoring... Logging to $LOG_FILE"
echo "Press [CTRL+C] to stop."

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [ -f "$ACTIVE_FILE" ]; then
        ACTIVE_ENV=$(cat "$ACTIVE_FILE")
    else
        ACTIVE_ENV="none"
    fi

    if [ "$ACTIVE_ENV" = "blue" ]; then
        PORT=3001
    elif [ "$ACTIVE_ENV" = "green" ]; then
        PORT=3002
    else
        PORT=0
    fi

    if [ "$PORT" -ne 0 ]; then
        STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/health)
        
        if [ "$STATUS" = "200" ]; then
            MESSAGE="SUCCESS - App is running on $ACTIVE_ENV (Port $PORT)"
        else
            MESSAGE="FAILURE - $ACTIVE_ENV is down or unreachable (HTTP $STATUS)"
        fi
    else
        MESSAGE="WARNING - No active environment detected."
    fi

    echo "[$TIMESTAMP] $MESSAGE" | tee -a "$LOG_FILE"
    
    sleep 5
done