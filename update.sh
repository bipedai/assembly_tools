#!/usr/bin/env bash
git pull;
docker pull bipedrobotics/camera_tools:latest;
docker pull tangramvision/cli:11.0.0;
pip install -r requirements.txt
git submodule init
git submodule update
./assembly_tool_setup.sh

