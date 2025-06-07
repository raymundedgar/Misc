#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils

# Kuzco
curl -fsSL https://devnet.inference.net/install.sh | sh
tmux new-session -d -s "kuzco"
tmux send-keys -t "inference node start --code 4be10240-1519-43dd-879b-818744aa2a06" C-m
tmux attach -t kuzco
