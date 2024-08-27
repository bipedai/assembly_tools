#!/usr/bin/env bash
ASSEMBLY_TOOL_DIR=$(dirname "$(realpath $0)")
# Check if flash tool is installed
if [ ! -f "$ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool/.is_installed" ]; then
    echo "Installing flash tool"
    cd $ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool
    ./INSTALL
    touch $ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool/.is_installed
fi
FLASHER=$ASSEMBLY_TOOL_DIR/flash_tool/rk-flash-tool/rk-burn-tool
# Check if the md5sum of the local image matches what is expected
LOCAL_IMAGE=$ASSEMBLY_TOOL_DIR/assets/*-emmc.img.xz
if [ -f "${LOCAL_IMAGE}" ]; then
    echo "File \"${LOCAL_IMAGE}\" exists"
else
    echo "Downloading image"
    gsutil -m cp "gs://biped-install/images/latest/*-emmc.img.xz" $ASSEMBLY_TOOL_DIR/assets/
    LOCAL_IMAGE=$ASSEMBLY_TOOL_DIR/assets/*-emmc.img.xz
    echo "Downloaded image $LOCAL_IMAGE"
fi
# COMPUTED_CHECKSUM=$(md5sum "$LOCAL_IMAGE" | awk '{ print $1 }')
# if [ "$COMPUTED_CHECKSUM" == "$EXPECTED_CHECKSUM" ]; then
#     echo "Checksums match - Flashing. $LOCAL_IMAGE"
    
#     echo "Finished flashing. Please wait until the led is blinking in blue...."
# else
#     echo "Checksums do not match."
# fi

$FLASHER -i $LOCAL_IMAGE