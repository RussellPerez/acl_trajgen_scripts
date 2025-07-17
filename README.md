# acl_trajgen_scripts
scripts to run three drones at the same time

1. Store both launch_drones_tmux.sh and go_all_drones.sh in ~/.local/bin
2. find /.bashrc file and modify to contain the following aliases/functions:
```
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
```
```
function triple_trajgen_go() {
    if [ ! -f ~/.active_drones ]; then
        echo "Error: No drones recorded. Run triple_trajgen_mocap first."
        return 1
    fi

    read -r D1 D2 D3 < ~/.active_drones
    go_all_drones.sh "$D1" "$D2" "$D3"
}
```
3. Then source the bash file
```
source ~/.bashrc
```
4. You can now run the scripts using aliasing:
```
# Step 1: Launch and attach to tmux sessions
triple_trajgen_mocap PX01 PX04 PX05

# Step 2: After they're ready, start the drones
triple_trajgen_go
```
