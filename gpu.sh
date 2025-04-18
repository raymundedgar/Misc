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

cat <<'EOF' > ~/onstart.sh
#!/bin/bash
tmux new-session -d -s "kuzco"
tmux send-keys -t "kuzco" "kuzco worker start --worker FxAJL3XlkTTrh5-MwkO-x --code 27b8451a-80f9-4991-af98-33d27d4a3fb4" C-m

tmux new-session -d -s "dria"
SESSION="dria"; for ((i=1; i<=20; i++)); do tmux new-window -t "$SESSION:" -n "$i"; tmux send-keys -t "$SESSION:$i" "dkn-compute-launcher --profile $i start" C-m; done
EOF

chmod +x ~/onstart.sh
