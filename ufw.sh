#!/bin/bash

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.178.0/24 to any port 22 proto tcp
sudo ufw allow from 192.168.178.0/24 to any port 1714:1764 proto udp
sudo ufw allow from 192.168.178.0/24 to any port 1714:1764 proto tcp
sudo ufw allow from 192.168.178.0/24 to any port 5353 proto udp
sudo ufw enable
