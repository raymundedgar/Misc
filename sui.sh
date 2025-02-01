#!/bin/bash

# Variables
SCRIPT_NAME="sui.sh"
SERVICE_NAME="sui.service"
TIMER_NAME="sui.timer"
SCRIPT_PATH="/usr/local/bin/${SCRIPT_NAME}"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"
TIMER_PATH="/etc/systemd/system/${TIMER_NAME}"

ADDRESS="$1"
cat <<EOF | sudo tee ${SCRIPT_PATH} > /dev/null
#!/bin/bash
ADDRESS="${ADDRESS}"

curl --location --request POST 'https://faucet.testnet.sui.io/v1/gas' \
--header 'Content-Type: application/json' \
--data-raw '{ "FixedAmountRequest": { "recipient": "\${ADDRESS}" }}'
EOF

sudo chmod +x ${SCRIPT_PATH}

cat <<EOF | sudo tee ${SERVICE_PATH} > /dev/null
[Unit]
Description=SUI Testnet Faucet Script
After=network.target

[Service]
Type=simple
ExecStart=${SCRIPT_PATH}
Restart=on-failure
EOF

cat <<EOF | sudo tee ${TIMER_PATH} > /dev/null
[Unit]
Description=Run My Script Every Hour

[Timer]
OnCalendar=hourly
Persistent=true
Unit=${SERVICE_NAME}

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable --now ${TIMER_NAME}
