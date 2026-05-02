#!/bin/bash
# rollback.sh - Reverts to the previous environment

PRODUCTION_ROOT="$HOME/local-production"
ACTIVE_FILE="$PRODUCTION_ROOT/active_env.txt"

if [ ! -f "$ACTIVE_FILE" ]; then
    echo "Error: No active environment file found. Cannot rollback."
    exit 1
fi

CURRENT_ENV=$(cat "$ACTIVE_FILE")

if [ "$CURRENT_ENV" = "blue" ]; then
    PREV_ENV="green"
    PREV_PORT=3002
else
    PREV_ENV="blue"
    PREV_PORT=3001
fi

echo "------------------------------------------"
echo "Rolling back from $CURRENT_ENV to $PREV_ENV..."
echo "------------------------------------------"

echo "Step 1: Starting $PREV_ENV environment..."
pm2 start "$PREV_ENV" 2>/dev/null

echo "Step 2: Updating active environment pointer..."
echo "$PREV_ENV" > "$ACTIVE_FILE"

echo "Step 3: Stopping $CURRENT_ENV environment..."
pm2 stop "$CURRENT_ENV" 2>/dev/null

echo "------------------------------------------"
echo "ROLLBACK SUCCESSFUL"
echo "Active environment is now: $PREV_ENV"
echo "------------------------------------------"