#!/bin/bash
yum install -y git python3
git clone https://github.com/fpera0248/399_CloudComputingFinal.git
cd 399_CloudComputingFinal/src
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp chatroom.service /etc/systemd/system
systemctl enable chatroom
systemctl start chatroom