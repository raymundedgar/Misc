#!/bin/bash

apt update && apt install -y sudo curl tmux

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh

kuzco worker start --worker CL7LPiShlb-h0CTiFD45w --code 48b615d9-19f1-42f2-85f8-a6d4d642d988
