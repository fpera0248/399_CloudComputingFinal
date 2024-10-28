#!/bin/bash

# Update system and install necessary packages
yum update -y
yum install -y git python3

# Clone the specified repository
cd /home/ec2-user
git clone https://github.com/fpera0248/399_CloudComputingFinal
cd 399_CloudComputingFinal/src

# Set up Python virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install required packages from requirements.txt
pip install -r requirements.txt

# Copy the service file to the systemd directory and set correct permissions
cp chatroom.service /etc/systemd/system/chatroom.service
chmod 644 /etc/systemd/system/chatroom.service

# Reload systemd daemon to recognize new service, enable it, and start the service
systemctl daemon-reload
systemctl enable chatroom
systemctl start chatroom

# Check and log the status of the chatroom service
systemctl status chatroom > /home/ec2-user/chatroom_setup.log 2>&1