#!/bin/bash
# deploy.sh - Blue-Green Deployment for Windows Git Bash

PRODUCTION_ROOT="$HOME/local-production"
ACTIVE_FILE="$PRODUCTION_ROOT/active_env.txt"

CURRENT_ENV=$(cat "$ACTIVE_FILE" 2>/dev/null || echo "green")

if [ "$CURRENT_ENV" = "green" ]; then
    TARGET_ENV="blue"
    TARGET_PORT=3001
else
    TARGET_ENV="green"
    TARGET_PORT=3002
fi

echo "------------------------------------------"
echo "Current Env: $CURRENT_ENV"
echo "Deploying to: $TARGET_ENV on port $TARGET_PORT"
echo "------------------------------------------"

echo "Step 1: Preparing directory..."
mkdir -p "$PRODUCTION_ROOT/$TARGET_ENV"
rm -rf "$PRODUCTION_ROOT/$TARGET_ENV"/*

echo "Step 2: Copying files..."
cp -r . "$PRODUCTION_ROOT/$TARGET_ENV/"

echo "Step 3: Installing dependencies in production..."
cd "$PRODUCTION_ROOT/$TARGET_ENV" || exit
rm -rf node_modules
npm install --production

echo "Step 4: Starting application with PM2..."
pm2 stop "$TARGET_ENV" 2>/dev/null
pm2 delete "$TARGET_ENV" 2>/dev/null
pm2 start app.js --name "$TARGET_ENV" -- node app.js --port $TARGET_PORT

echo "Step 5: Running Health Check..."
sleep 5 
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)

if curl -s http://localhost:3000/health | grep "OK" > /dev/null; then
    echo "SUCCESS: Health check passed!"
    echo "$TARGET_ENV" > "$ACTIVE_FILE"
    
    echo "Stopping old environment ($CURRENT_ENV)..."
    pm2 stop "$CURRENT_ENV" 2>/dev/null
    echo "DEPLOYMENT COMPLETE!"
else
    echo "FAILURE: Health check failed on http://localhost:3000/health"
    pm2 stop "$TARGET_ENV"
    exit 1
fi