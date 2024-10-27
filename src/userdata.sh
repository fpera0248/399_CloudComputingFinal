#!/bin/bash
yum install -y git
git clone https://github.com/cs399f24/rocketchat-ec2
cd rocketchat-ec2
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
gunicorn -w 1 -b 0.0.0.0:80 app:app
