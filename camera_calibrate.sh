#! /bin/sh

# By using --device-cgroup-rule flag we grant the docker continer permissions -
# to the camera and usb endpoints of the machine.
# It also mounts the /dev directory of the host platform on the contianer
# Mount the docker since calibration script contains docker commands

docker run -it --rm \
    --privileged \
    -v /dev:/dev \
    -v $(pwd)/outputs:/out/ \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --device-cgroup-rule "c 81:* rmw" \
    --device-cgroup-rule "c 189:* rmw" \
    bipedrobotics/camera_calibration:latest