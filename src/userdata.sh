#!/bin/bash
set -e

# Update and install necessary packages
yum update -y
yum install -y git python3 python3-pip

# Clone the repository
git clone https://github.com/fpera0248/399_CloudComputingFinal.git /home/ec2-user/399_CloudComputingFinal

# Navigate to the correct directory
cd /home/ec2-user/399_CloudComputingFinal/src

# Set up virtual environment and install dependencies
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pip install gunicorn  # Add this line to install Gunicorn

# Set up the chatroom service
cat << EOF > /etc/systemd/system/chatroom.service
[Unit]
Description=Chatroom Flask Application
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/399_CloudComputingFinal/src
ExecStart=/home/ec2-user/399_CloudComputingFinal/src/.venv/bin/gunicorn --bind 0.0.0.0:8000 "app:app"
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Set correct permissions
chown -R ec2-user:ec2-user /home/ec2-user/399_CloudComputingFinal

# Enable and start the service
systemctl daemon-reload
systemctl enable chatroom
systemctl start chatroom

echo "Setup completed successfully."