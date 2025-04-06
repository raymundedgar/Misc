#!/bin/bash

apt update && apt install -y sudo curl tmux

# Gensyn
curl -sSL https://raw.githubusercontent.com/zunxbt/installation/main/node.sh | bash
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl screen git yarn && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt update && sudo apt install -y yarn
rm -rf rl-swarm && git clone https://github.com/SKaaalper/rl-swarm.git && cd rl-swarm

cat << 'EOF' > "/root/onstart.sh"
#!/bin/bash
tmux new-session -d -s "gensyn"
tmux send-keys -t "gensyn" "cd /root/rl-swarm && python3 -m venv .venv && source .venv/bin/activate" C-m
tmux attach -t "gensyn"
EOF
