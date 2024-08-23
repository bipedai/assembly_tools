#!/usr/bin/env bash
ASSEMBLY_TOOL_DIR=$(dirname "$(realpath $0)")
if [ ! -f "$ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool/.is_installed" ]; then
    echo "Installing flash tool"
    cd $ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool
    ./INSTALL
    touch $ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool/.is_installed
fi
FLASHER=$ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool/rk-burn-tool

$FLASHER $@