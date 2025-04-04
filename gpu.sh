#!/bin/bash

apt update && apt install -y sudo curl tmux pciutils lshw

# Kuzco
curl -fsSL https://inference.supply/install.sh | sh

# Dria
curl -fsSL https://ollama.com/install.sh | sh
curl -fsSL https://dria.co/launcher | bash
export PATH="$HOME/.dria/bin:$PATH"

# Edit the auto run when reboot
echo "#!/bin/bash" > /root/onstart.sh

echo "# Kuzco" >> /root/onstart.sh
echo "SESSION_NAME=\"kuzco\"" >> /root/onstart.sh
echo "COMMAND=\"\"" >> /root/onstart.sh
echo "tmux new-session -d -s $SESSION_NAME" >> /root/onstart.sh
echo "tmux send-keys -t $SESSION_NAME \"$COMMAND\" C-m" >> /root/onstart.sh

echo "# Gensyn" >> /root/onstart.sh
echo "SESSION_NAME=\"gensyn\"" >> /root/onstart.sh
echo "tmux new-session -d -s $SESSION_NAME" >> /root/onstart.sh
echo "COMMAND=\"cd /root/rl-swarm && python3 -m venv .venv && source .venv/bin/activate\"" >> /root/onstart.sh
echo "tmux send-keys -t $SESSION_NAME \"$COMMAND\" C-m" >> /root/onstart.sh

echo "# Dria" >> /root/onstart.sh
echo "SESSION_NAME=\"dria\"" >> /root/onstart.sh
echo "tmux new-session -d -s $SESSION_NAME" >> /root/onstart.sh
echo "COMMAND=\"dkn-compute-launcher start\"" >> /root/onstart.sh
echo "tmux send-keys -t $SESSION_NAME \"$COMMAND\" C-m" >> /root/onstart.sh
