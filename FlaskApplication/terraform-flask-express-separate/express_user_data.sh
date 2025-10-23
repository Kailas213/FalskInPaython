#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

sudo  apt update -y
sudo  apt install -y curl nodejs npm

sudo  mkdir -p /opt/express_app
sudo  cd /opt/express_app

sudo chown -R ubuntu:ubuntu /opt/express_app

# Minimal Express app
cat > app.js << 'JS'
const express = require('express')
const app = express()
const PORT = 3000
app.get('/', (req, res) => res.send('Hello from Express on port 3000!'))
app.listen(PORT, '0.0.0.0', () => console.log(`Express listening on ${PORT}`))
JS"

cat > package.json << 'PKG'
{
  "name": "express-sample",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
PKG"

sudo  npm install --production

# Systemd service
sudo tee /etc/systemd/system/express-app.service > /dev/null << 'UNIT'
[Unit]
Description=Express App
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/express_app
ExecStart=/usr/bin/node /opt/express_app/app.js
Restart=always
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
UNIT


sudo  systemctl daemon-reload
sudo  systemctl enable express-app.service
sudo  systemctl start express-app.service
