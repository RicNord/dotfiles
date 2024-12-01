#!/bin/bash

# This scrip will encrypt an already existing partition and then creates a
# filesystem on the partition.

# Bash stric mode
set -euxo pipefail

# Colors
RED='\033[0;31m'
BBlue='\033[1;34m'
NC='\033[0m' # NO COLOR

# Get user input for the settings
echo -e "${BBlue}The following disks are available on your system:\n${NC}"
lsblk | grep -v 'rom' | grep -v 'loop'
echo -e "\n"

echo -e "${RED}WARNING ALL CURRENT DATA ON THE PARTITION WILL BE LOST.\n${NC}"
read -rp 'Select the target partition. Example sda1 or nvme0n1p1: ' TARGET_PARTITION
echo -e "\n"

sudo cryptsetup luksFormat \
    --verbose \
    --verify-passphrase \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --hash sha512 \
    --iter-time 3000 \
    --use-random \
    --type luks2 \
    "/dev/${TARGET_PARTITION}"
echo -e "\n"

echo -e "${BBlue}Decrypt/open partition \n${NC}"
sudo cryptsetup --verbose open "/dev/$TARGET_PARTITION" tmpdecrypted
echo -e "\n"

echo -e "${BBlue}Make filesystem ext4\n${NC}"
sudo mkfs --type ext4 --verbose /dev/mapper/tmpdecrypted
echo -e "\n"

sleep 5

echo -e "${BBlue}Set owner\n${NC}"
UUID="$(uuidgen)"
sudo mount --mkdir /dev/mapper/tmpdecrypted /tmp/"$UUID"
sudo chown "$(id -u)":"$(id -g)" /tmp/"$UUID"
sudo umount /tmp/"$UUID"

echo -e "${BBlue}Encrypt/close partition \n${NC}"
sudo cryptsetup --verbose close tmpdecrypted
echo -e "${BBlue}Done! \n${NC}"
