#!/bin/bash

apt update && apt install -y sudo curl tmux

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh
