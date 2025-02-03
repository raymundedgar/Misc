#!/bin/bash

echo "Modified version of dante4rt's script"

sudo apt update
sudo apt install libssl3
sudo apt install bc -y

# Function to get total RAM in GB
get_total_ram_gb() {
    total_ram_bytes=$(free -b | awk '/^Mem:/{print $2}')
    total_ram_gb=$(echo "scale=2; $total_ram_bytes / 1024 / 1024 / 1024" | bc)
    echo "$total_ram_gb"
}
RAM=$(get_total_ram_gb)
if (( $(echo "$RAM < 4" | bc -l) )); then
  echo "RAM must be at least 4GB. Exiting."
  exit 1
fi
RAM=4

get_total_disk_size_gb() {
    total_disk_size_gb=$(df -BG --total | awk '/^total/{print $2}' | tr -d 'G')
    echo "$total_disk_size_gb"
}
DISK=$(get_total_disk_size_gb)
if [ "$DISK" -lt 100 ]; then
  echo "Disk space must be at least 100GB. Exiting."
  exit 1
fi

cd $HOME

echo "Stopping any process using port 8003..."
PID=$(lsof -ti :8003)
if [ -n "$PID" ]; then
  echo "Killing process with PID: $PID"
  kill -9 $PID
else
  echo "No process found using port 8003."
fi

echo "Stopping any DCDND service..."
systemctl stop dcdnd && systemctl disable dcdnd

echo "Creating $HOME/pipe-network folder..."
mkdir -p $HOME/pipe-network

binary_url='https://dl.pipecdn.app/v0.2.2/pop'

if [[ $binary_url == https* ]]; then
    echo "Downloading pop binary..."
    wget -O $HOME/pipe-network/pop "$binary_url"
    chmod +x $HOME/pipe-network/pop
    echo "Binary downloaded and made executable."
else
    echo "Invalid URL. Please ensure the link starts with 'https'."
    exit 1
fi

SERVICE_FILE="/etc/systemd/system/pipe.service"
echo "Creating $SERVICE_FILE..."

PUBKEY="$1"
cat <<EOF | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=Pipe POP Node Service
After=network.target
Wants=network-online.target

[Service]
User=$USER
ExecStart=$HOME/pipe-network/pop \
    --ram=$RAM \
    --pubKey $PUBKEY \
    --max-disk $DISK \
    --cache-dir $HOME/pipe-network/download_cache
    --signup-by-referral-route bff3cba920cfcfca
Restart=always
RestartSec=5
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=dcdn-node
WorkingDirectory=$HOME/pipe-network

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd daemon and starting pipe service..."
sudo systemctl daemon-reload && \
sudo systemctl enable pipe && \
sudo systemctl restart pipe
