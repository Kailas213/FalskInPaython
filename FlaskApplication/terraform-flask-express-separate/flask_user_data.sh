#!/bin/bash
set -e
sudo apt update -y
sudo apt install -y python3 python3-venv python3-pip
sudo mkdir -p /opt/flask_app
cd /opt/flask_app


sudo chown -R ubuntu:ubuntu /opt/flask_app


# Create minimal Flask app
cat > app.py << 'PY'
from flask import Flask
app = Flask(__name__)
@app.route('/')
def index():
    return 'Hello from Flask on port 5000!'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
PY

# Setup venv

sudo  python3 -m venv venv

sudo chown -R ubuntu:ubuntu ~/venv

source venv/bin/activate

pip install --upgrade pip
pip install Flask==2.2.5

# Systemd service

sudo tee /etc/systemd/system/flask-app.service > /dev/null << 'UNIT'
[Unit]
Description=Flask App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/flask_app
ExecStart=/home/ubuntu/venv/bin/python app.py
Restart=always
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
UNIT

sudo  systemctl daemon-reload
sudo  systemctl enable flask-app.service
sudo  systemctl start flask-app.service
