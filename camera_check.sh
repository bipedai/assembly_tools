#! /bin/sh

# By using --device-cgroup-rule flag we grant the docker continer permissions -
# to the camera and usb endpoints of the machine.
# It also mounts the /dev directory of the host platform on the contianer
camera_tools()
{
    docker run -it --rm --user="$(id -u):$(id -g)"\
    --privileged \
    -v /dev:/dev \
    --device-cgroup-rule "c 81:* rmw" \
    --device-cgroup-rule "c 189:* rmw" \
    bipedrobotics/camera_tools:latest \
    -- "$@";
}

camera_tools --mode check
