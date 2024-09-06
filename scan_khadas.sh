
#!/usr/bin/env bash
network_sub=$(hostname -I | awk '{print $1}' | cut -d '.' -f 1-3)
candidates=$(nmap -Pn --min-rate 1000 -p 22 -T 5 $network_sub.0-255 --open | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

echo "Try connecting to one of the following IPs: \n$candidates \n with ssh khadas@<IP>"

