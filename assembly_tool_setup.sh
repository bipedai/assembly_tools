#!/usr/bin/env bash

ASSEMBLY_TOOL_DIR=$(dirname "$(realpath $0)")
echo "Setting up $ASSEMBLY_TOOL_DIR"
alias camera_check="source $ASSEMBLY_TOOL_DIR/camera_check.sh"
alias camera_fw_update="python $ASSEMBLY_TOOL_DIR/fw_update.py"

alias assembly_tool_update="source $ASSEMBLY_TOOL_DIR/update.sh"
alias assembly_tool_version="git rev-list HEAD -1"
alias assembly_tool_help="batcat $ASSEMBLY_TOOL_DIR/README.md"
