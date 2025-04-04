#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils lshw

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh

# Dria
curl -fsSL https://ollama.com/install.sh | sh
curl -fsSL https://dria.co/launcher | bash
export PATH="$HOME/.dria/bin:$PATH"
