#!/usr/bin/env bash

ASSEMBLY_TOOL_DIR=$(dirname "$(realpath $0)")
echo "Setting up $ASSEMBLY_TOOL_DIR"

TANGRAM_KEY_FILE="$HOME/.tangram-key"
if [ -f $TANGRAM_KEY_FILE ]; then
    export TANGRAM_KEY=$(cat $TANGRAM_KEY_FILE )
else
    printf "MISSING TANGRAM KEY"
fi

GCLOUD_JSON="$HOME/.gcp_biped_install.json"

gcloud auth activate-service-account --key-file=$GCLOUD_JSON;

printf "Commands:
    camera_check : Checks that the connected camera(s) work and are correctly assembled
    camera_fw_update : Update the camera firmware. Do not interrupt or disconnect the camera(s) while the update is in progress.
    camera_calibrate : Calibrate the camera module. See 

    board_flash : Flash the board
    board_scan : Scan the boards connected to the network

    assembly_qc : Launches  the visualization for the final quality check once the full device is assembled and flashed

    assembly_tool_update : Update the assembly tool
    assembly_tool_version : Get the current version of the assembly tool. To send to paul@biped.ai if there is a problem

    assembly_tool_help : Show the help for the assembly tool"


alias camera_check="bash $ASSEMBLY_TOOL_DIR/camera_check.sh"
alias camera_fw_update="python $ASSEMBLY_TOOL_DIR/fw_update.py"
alias camera_calibrate="bash $ASSEMBLY_TOOL_DIR/camera_calibrate.sh"

alias board_flash="bash $ASSEMBLY_TOOL_DIR/flash_board.sh"
alias board_scan="bash $ASSEMBLY_TOOL_DIR/scan_khadas.sh"

alias assembly_tool_update="cd $ASSEMBLY_TOOL_DIR && ./update.sh"
alias assembly_tool_version="cd $ASSEMBLY_TOOL_DIR && git rev-list HEAD -1"

alias assembly_tool_help="batcat $ASSEMBLY_TOOL_DIR/README.md"


alias assembly_qc="rerun &"