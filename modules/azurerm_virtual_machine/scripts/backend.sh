#!/bin/bash

set -e

echo "=== Axion Backend VM Setup Started ==="

# Update packages
apt-get update

# Install required packages
apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv

# Move to admin user's home
cd /home/adminuser

# Clone backend repository
if [ ! -d "axion-telemetry-query-service" ]; then
    git clone https://github.com/devopsinsiders/axion-telemetry-query-service.git
fi

cd /home/adminuser/axion-telemetry-query-service

# Create Python virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Install Python dependencies
/home/adminuser/axion-telemetry-query-service/venv/bin/pip install --upgrade pip

/home/adminuser/axion-telemetry-query-service/venv/bin/pip install -r requirements.txt

# Give ownership to adminuser
chown -R adminuser:adminuser /home/adminuser/axion-telemetry-query-service

echo "=== Axion Backend VM Setup Completed ==="