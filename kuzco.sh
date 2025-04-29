#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh
tmux new-session -d -s "kuzco"
tmux send-keys -t "kuzco" "kuzco worker start --worker FxAJL3XlkTTrh5-MwkO-x --code 27b8451a-80f9-4991-af98-33d27d4a3fb4" C-m
