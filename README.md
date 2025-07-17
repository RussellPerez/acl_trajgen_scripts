# acl_trajgen_scripts
scripts to run three drones at the same time

1. Store both launch_drones_tmux.sh and go_all_drones.sh in ~/.local/bin
2. find /.bashrc file and modify to contain the following aliases/functions:
function triple_trajgen_mocap(){
  launch_drones_tmux.sh "$@"
}
