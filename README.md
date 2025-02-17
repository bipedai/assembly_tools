# Assembly tools

Scripts around the docker images used for the assembly of the biped products.

## Requirements

docker

gcloud

```bash
sudo apt-get install apt-transport-https ca-certificates gnupg curl sudo -y
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli -y
```

### Always discoverable

One of the tests for the final QC is to check that the NOA device has a working bluetooth antenna. For that matter, the automated test will try to discover any nearby bluetooth device.

To ensure that there is at least one, we need the host computer to always be discoverable by bluetooth

```
sudo nano /etc/bluetooth/main.conf

# Add / edit the line
DiscoverableTimeout = 0

# reboot the computer (only needed on first setup)
```

## Authentification

> Needs to be done only once

`docker login -u bipedteam`

Enter the password provided by <paul@biped.ai> and press Enter

`gcloud auth activate-service-account --key-file="~/.gcp_biped_install.json"`

## Camera check

## Firmware update

## Camera calibration

## Final quality check
