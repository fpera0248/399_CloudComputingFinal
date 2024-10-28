#!/bin/bash
yum install -y git python3
git clone https://github.com/cs399f24/rocketchat-ec2
cd rocketchat-ec2/src
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
gunicorn -w 1 -b 0.0.0.0:80 app:app
