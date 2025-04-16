#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils

# open tmux session
tmux

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh

# Dria
curl -fsSL https://dria.co/launcher | bash
export PATH="$HOME/.dria/bin:$PATH"
cd ~/.dria && mkdir -p dkn-compute-launcher
tmux new-session -d -s dria

curl -fsSL https://ollama.com/install.sh | sh
