#!/bin/bash
set -e

# Update and install necessary packages
yum update -y
yum install -y git python3

# Give time for networking to initialize
sleep 30

# Set up the default user (adjust if needed)
DEFAULT_USER="ec2-user"

# Clone the repository with retry logic
MAX_RETRIES=3
RETRY_DELAY=10
for i in $(seq 1 $MAX_RETRIES); do
    if git clone https://github.com/fpera0248/399_CloudComputingFinal.git /home/$DEFAULT_USER/399_CloudComputingFinal; then
        break
    fi
    if [ $i -eq $MAX_RETRIES ]; then
        echo "Repository cloning failed after $MAX_RETRIES attempts. Exiting setup."
        exit 1
    fi
    echo "Clone attempt $i failed. Retrying in $RETRY_DELAY seconds..."
    sleep $RETRY_DELAY
done

# Navigate to the correct directory
cd /home/$DEFAULT_USER/399_CloudComputingFinal/src || exit 1

# Set up virtual environment and install dependencies
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Set up and start the chatroom service
if [ -f chatroom.service ]; then
    cp chatroom.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable chatroom
    systemctl start chatroom

    # Verify the service status
    systemctl status chatroom
else
    echo "chatroom.service file not found. Skipping service setup."
fi

# Change ownership of the cloned repository
chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/399_CloudComputingFinal

echo "Setup completed successfully."