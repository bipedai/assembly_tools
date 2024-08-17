#!/usr/bin/env bash
git pull;
docker pull bipedrobotics/camera_tools:latest;
docker pull bipedrobotics/camera_calibration:latest;
pip install -r requirements.txt
