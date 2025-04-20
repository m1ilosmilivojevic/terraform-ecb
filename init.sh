#!/bin/bash
sudo mkfs -t ext4 /dev/xvdf
sudo mkdir /data
sudo mount /dev/xvdf /data
echo "/dev/xvdf /data ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab