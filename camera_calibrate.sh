#!/bin/bash
set -eu
COPILOT_REPO="/home/paul/biped/repos/copilot"
OBJ="charuco_7x10_id0.json"

CALIB_UUID=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 8)
CALIBRATION_FOLDER="/tmp/$CALIB_UUID"
mkdir -p $CALIBRATION_FOLDER
chown $(id -u):$(id -g) $CALIBRATION_FOLDER


camera_tools()
{
    docker run -it --rm --user="$(id -u):$(id -g)"\
    --privileged \
    -v /dev:/dev \
    -v $CALIBRATION_FOLDER:/out/ \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --device-cgroup-rule "c 81:* rmw" \
    --device-cgroup-rule "c 189:* rmw" \
    camera_tools:latest \
    -- "$@";
}

metrical() {
    docker run --rm --init --user="$(id -u):$(id -g)" \
    --volume="$CALIBRATION_FOLDER:/$CALIB_UUID" \
    --workdir="/$CALIB_UUID" \
    --net=host \
    tangramvision/cli:latest \
    --license="key/$TANGRAM_KEY" \
	  "$@";
}



camera_tools --mode calibrate -o /out/$CALIB_UUID


cp $COPILOT_REPO/scripts/constants/$OBJ $CALIBRATION_FOLDER
_INIT_PLEX_FILE="tmp_plex.json"
_UMBRA_OUTPUT="umbra_$CALIB_UUID.json"


metrical init \
     --topic-to-model *:opencv_radtan \
     --preset-device RealSense435:[cam_right_left_ir,cam_right_right_ir,_] \
     --preset-device RealSense435:[cam_middle_left_ir,cam_middle_right_ir,_] \
     --preset-device RealSense435:[cam_left_left_ir,cam_left_right_ir,_] \
     $CALIB_UUID $_INIT_PLEX_FILE


echo "Computing calibration"
metrical calibrate --interactive --disable-filter  $CALIB_UUID $_INIT_PLEX_FILE $OBJ --output-json $_UMBRA_OUTPUT

echo "Generating the calibration table"
jq .plex "$CALIBRATION_FOLDER/$_UMBRA_OUTPUT" > "$CALIBRATION_FOLDER/calib_table.json"
mv $CALIBRATION_FOLDER/$CALIB_UUID/camera_position_to_camera_serial.json $CALIBRATION_FOLDER

camera_tools --mode flash_calibration -i /out