#!/bin/sh
set -e

# Put the uploader script in a sensible place
chmod +x stream-uploader.sh
cp stream-uploader.sh /usr/local/bin

# The user you want the service to run as - defaults to current user
RUN_AS=$(id -un)

# Create systemd service
sudo tee /etc/systemd/system/stream-uploader.service > /dev/null <<EOF
[Unit]
Description=Stream Uploader
After=network.target

[Service]
Type=simple
User=${RUN_AS}
ExecStart=/usr/local/bin/stream-uploader.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable stream-uploader.service
systemctl start stream-uploader

