#!/bin/bash

# Usage: ./go_all_drones.sh PX01 PX04 PX05

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 PX01 PX04 PX05"
    exit 1
fi

DRONES=("$1" "$2" "$3")
USER=swarm

for DRONE in "${DRONES[@]}"; do
    echo "Running trajgen_go on $DRONE..."
    ssh ${USER}@${DRONE} "bash -i -c 'trajgen_go'" &
done

wait
echo "All drones have been started."
