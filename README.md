# acl_trajgen_scripts
scripts to run three drones at the same time

1. Store launch_drones_tmux.sh, go_all_drones.sh, and run_flight.sh in ~/.local/bin
2. find /.bashrc file and modify to contain the following aliases/functions:
```
#starting up three drone tmux
function triple_trajgen_mocap() {
    if [ "$#" -ne 3 ]; then      
        echo "Usage: triple_trajgen_mocap PX01 PX02 PX03"
        return 1
    fi

    # Save drone names for reuse
    echo "$1 $2 $3" > ~/.active_drones

    # Run the tmux launch script
    launch_drones_tmux.sh "$1" "$2" "$3"
}

#same functionality as trajgen_go but for the three drones
function triple_trajgen_go() {
    if [ ! -f ~/.active_drones ]; then
        echo "Error: No drones recorded. Run triple_trajgen_mocap first."
        return 1
    fi

    read -r D1 D2 D3 < ~/.active_drones
    go_all_drones.sh "$D1" "$D2" "$D3"
}

# General-purpose flight runner
alias flyset='run_flight.sh'

# For halfbay configuration (flight name and drones required)
function flyhalf() {
    if [ "$#" -ne 4 ]; then
        echo "Usage: flyhalf flight_name DRONE1 DRONE2 DRONE3"
        return 1
    fi
    run_flight.sh halfbay "$@"
}

# For fullbay configuration (flight name and drones required)
function flyfull() {
    if [ "$#" -ne 4 ]; then
        echo "Usage: flyfull flight_name DRONE1 DRONE2 DRONE3"
        return 1
    fi
    run_flight.sh fullbay "$@"
}
```
3. Then source the bash file
```
source ~/.bashrc
```
also make them executable
```
chmod +x ~/.local/bin/*.sh
```
4. You can now run the scripts using aliasing. There are two different ways you can do this. The first way is for if you just want to launch the three drones as is without adjust their yaml files, i.e. you are not flying the predetermined flight experiment:
```
# Step 1: Launch and attach to tmux sessions
triple_trajgen_mocap PX01 PX04 PX05

# Step 2: After they're ready, start the drones
triple_trajgen_go
```

The second way is for when you are running the flight experiments:
```
#Step 1: determine if you are using just half of the highbay or the full highbay space, use either one
flyhalf flight_1 PX01 PX02 PX03
flyfull flight_2 PX04 PX05 PX06

#Step 2: After they're ready, start the drones
triple_trajgen_go
