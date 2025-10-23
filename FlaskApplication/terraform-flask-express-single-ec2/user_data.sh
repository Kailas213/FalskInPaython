#!/bin/bash
#cloud-config
set -e
exec > /var/log/user-data.log 2>&1

# Update packages
sudo apt update -y
sudo apt upgrade -y

# Install Python3, pip, Node.js, git
sudo apt install -y python3 python3-pip python3-venv git curl
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
sudo apt install -y nodejs

# Create app directories
sudo mkdir -p /opt/flask_app /opt/express_app
sudo chown -R ubuntu:ubuntu /opt/flask_app /opt/express_app

# Flask app
cat > /opt/flask_app/app.py << 'PY'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello from Flask on Ubuntu port 5000!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
PY

cat > /opt/flask_app/requirements.txt << 'REQ'
Flask==2.2.5
REQ

# Express app
cat > /opt/express_app/app.js << 'JS'
const express = require('express')
const app = express()
const PORT = process.env.PORT || 3000
app.get('/', (req, res) => res.send('Hello from Express on Ubuntu port 3000!'))
app.listen(PORT, '0.0.0.0', () => console.log(`Express listening on ${PORT}`))
JS

cat > /opt/express_app/package.json << 'PKG'
{
  "name": "express-sample",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  }
}
PKG

# Install dependencies
sudo python3 -m pip install -r /opt/flask_app/requirements.txt
cd /opt/express_app && npm install --production

# Create systemd service for Flask
cat > /etc/systemd/system/flask-app.service << 'UNIT'
[Unit]
Description=Flask App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/flask_app
ExecStart=/usr/bin/python3 /opt/flask_app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
UNIT

# Create systemd service for Express
cat > /etc/systemd/system/express-app.service << 'UNIT'
[Unit]
Description=Express App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/express_app
ExecStart=/usr/bin/node /opt/express_app/app.js
Restart=always

[Install]
WantedBy=multi-user.target
UNIT

# Enable and start both services
sudo systemctl daemon-reload
sudo systemctl enable flask-app.service express-app.service
sudo systemctl start flask-app.service express-app.service
