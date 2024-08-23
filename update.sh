#!/usr/bin/env bash
git pull;
docker pull bipedrobotics/camera_tools:latest;
pip install -r requirements.txt
git submodule init
git submodule update