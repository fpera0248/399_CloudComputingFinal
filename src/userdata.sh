#!/bin/bash

# Update system and install dependencies
yum update -y
yum install -y git python3 python3-pip

# Clone repository to the correct home directory
cd /home/ec2-user
git clone https://github.com/fpera0248/399_CloudComputingFinal.git
cd rocketchat-ec2/src

# Set up Python virtual environment with correct permissions
python3 -m venv .venv
source .venv/bin/activate
pip install flask flask-socketio gevent-websocket

# Create correct app.py with proper Socket.IO configuration
cat > app.py << 'EOL'
from flask import Flask, render_template
from flask_socketio import SocketIO, emit, send

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins="*")  # Allow all origins for testing

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('message')
def handle_message(message):
    print('received message: ' + message)
    send(message, broadcast=True)

@socketio.on('connect')
def test_connect():
    emit('my response', {'data': 'Connected'})

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5000, allow_unsafe_werkzeug=True)
EOL

# Modify index.html to use correct Socket.IO connection
cat > templates/index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Chat Room</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.0.1/socket.io.js"></script>
    <script type="text/javascript">
        var socket = io({
            transports: ['websocket'],
            cors: {
                origin: "*"
            }
        });
        
        socket.on('connect', function() {
            console.log('Connected to server');
        });

        socket.on('message', function(msg) {
            var ul = document.getElementById('messages');
            var li = document.createElement('li');
            li.appendChild(document.createTextNode(msg));
            ul.appendChild(li);
        });

        function sendMessage() {
            var input = document.getElementById('message');
            socket.send(input.value);
            input.value = '';
        }
    </script>
</head>
<body>
    <ul id="messages"></ul>
    <input type="text" id="message" placeholder="Type your message">
    <button onclick="sendMessage()">Send</button>
</body>
</html>
EOL

# Create systemd service file with correct paths and permissions
cat > /etc/systemd/system/chatroom.service << 'EOL'
[Unit]
Description=Launch the Chatroom Flask server
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/rocketchat-ec2/src
Environment="PATH=/home/ec2-user/rocketchat-ec2/src/.venv/bin"
ExecStart=/home/ec2-user/rocketchat-ec2/src/.venv/bin/python3 app.py

[Install]
WantedBy=multi-user.target
EOL

# Fix permissions
chown -R ec2-user:ec2-user /home/ec2-user/rocketchat-ec2

# Enable and start service
systemctl daemon-reload
systemctl enable chatroom
systemctl start chatroom