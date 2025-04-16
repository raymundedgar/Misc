#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils

# open tmux session
tmux

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh

# Dria
curl -fsSL https://dria.co/launcher | bash
export PATH="$HOME/.dria/bin:$PATH"
curl -fsSL https://ollama.com/install.sh | sh
