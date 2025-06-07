#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils

# Kuzco
curl -fsSL https://devnet.inference.net/install.sh | sh
tmux new-session -d -s "kuzco"
tmux send-keys -t "inference node start --code 4be10240-1519-43dd-879b-818744aa2a06" C-m

# Dria
curl -fsSL https://dria.co/launcher | bash
export PATH="$HOME/.dria/bin:$PATH"
cd ~/.dria && mkdir -p dkn-compute-launcher
tmux new-session -d -s dria
curl -fsSL https://ollama.com/install.sh | sh

cat <<'EOF' > ~/onstart.sh
#!/bin/bash
tmux new-session -d -s "kuzco"
tmux send-keys -t inference node start --code 4be10240-1519-43dd-879b-818744aa2a06" C-m

tmux new-session -d -s "dria"
SESSION="dria"; for ((i=1; i<=20; i++)); do tmux new-window -t "$SESSION:" -n "$i"; tmux send-keys -t "$SESSION:$i" "dkn-compute-launcher --profile $i start" C-m; done
EOF
