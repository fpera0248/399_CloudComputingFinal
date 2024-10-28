#!/bin/bash
# Update and install necessary packages
yum update -y
yum install -y git python3

# Give time for networking to initialize
sleep 10

# Clone the repository and navigate to the correct directory
if git clone https://github.com/fpera0248/399_CloudComputingFinal.git; then
    cd 399_CloudComputingFinal/src || exit
else
    echo "Repository cloning failed. Exiting setup."
    exit 1
fi

# Set up virtual environment and install dependencies
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Set up and start the chatroom service
cp chatroom.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable chatroom
systemctl start chatroom

# Verify the service status
systemctl status chatroom