#!/bin/bash

# Usage: run_flight.sh bay_mode flight_name DRONE1 DRONE2 DRONE3
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 bay_mode flight_name DRONE1 DRONE2 DRONE3"
    echo "Example: $0 halfbay flight_1 PX01 PX02 PX03"
    exit 1
fi

BAY_MODE="$1"
FLIGHT_NAME="$2"
MISSION_DIR="$HOME/missions/$BAY_MODE/$FLIGHT_NAME"
USER=swarm
REMOTE_YAML_PATH=~/code/trajgen_ws/src/trajectory_generator_ros2/config/default.yaml

# Drones from arguments
DRONES=("$3" "$4" "$5")

# Validate mission directory
if [ ! -d "$MISSION_DIR" ]; then
    echo "Error: Mission directory '$MISSION_DIR' not found"
    exit 1
fi

YAML_FILES=($(ls "$MISSION_DIR"/*.yaml | sort))
if [ "${#YAML_FILES[@]}" -ne 3 ]; then
    echo "Error: Expected 3 YAML files in $MISSION_DIR, found ${#YAML_FILES[@]}"
    exit 1
fi

# Upload YAMLs to each drone
for i in {0..2}; do
    SRC_YAML="${YAML_FILES[$i]}"
    DRONE="${DRONES[$i]}"
    echo "Uploading $(basename "$SRC_YAML") to $DRONE..."
    scp "$SRC_YAML" ${USER}@${DRONE}:"$REMOTE_YAML_PATH"
done

# Launch mocap sessions
echo "Launching trajgen_mocap on drones: ${DRONES[*]}"
triple_trajgen_mocap "${DRONES[@]}"
