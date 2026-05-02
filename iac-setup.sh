#!/bin/bash
# iac-setup.sh
echo "Starting Infrastructure Provisioning..."

if ! command -v node &> /dev/null; then
    echo "Node.js not found. Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "Installing PM2..."
npm install -g pm2

echo "Creating deployment directories..."
mkdir -p ~/local-production/blue
mkdir -p ~/local-production/green
mkdir -p ~/local-production/router

touch ~/local-production/active_env.txt

echo "Environment Provisioned Successfully!"
echo "Directories created in: $HOME/local-production/"