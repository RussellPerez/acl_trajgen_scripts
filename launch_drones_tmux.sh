#!/bin/bash

# Usage check
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 PX01 PX04 PX05"
    exit 1
fi

SESSION_NAME="drones"
USER="swarm"

# Read drone names from arguments
DRONES=("$1" "$2" "$3")

# Create a new tmux session
tmux new-session -d -s $SESSION_NAME -n drone_tmux

# First drone pane
tmux send-keys -t ${SESSION_NAME}:0 "ssh $USER@${DRONES[0]}" C-m
tmux send-keys -t ${SESSION_NAME}:0 "trajgen_mocap" C-m

# Second drone: horizontal split
tmux split-window -h -t ${SESSION_NAME}:0
tmux send-keys -t ${SESSION_NAME}:0.1 "ssh $USER@${DRONES[1]}" C-m
tmux send-keys -t ${SESSION_NAME}:0.1 "trajgen_mocap" C-m

# Third drone: vertical split
tmux split-window -v -t ${SESSION_NAME}:0.1
tmux send-keys -t ${SESSION_NAME}:0.2 "ssh $USER@${DRONES[2]}" C-m
tmux send-keys -t ${SESSION_NAME}:0.2 "trajgen_mocap" C-m

# Arrange layout
tmux select-layout -t ${SESSION_NAME} tiled

# Attach to session
tmux attach -t $SESSION_NAME
