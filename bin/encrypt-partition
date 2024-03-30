#!/bin/bash

# This scrip will encrypt an already existing partition and then creates a
# filesystem on the partition.

# TODO: verifications of correctly selected partition
# verbose logging
# selection of filesystem
# sudo -A inside script

# Bash stric mode
set -eo pipefail

# Colors
BBlue='\033[1;34m'
NC='\033[0m' # NO COLOR

# Check if user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root." 1>&2
    exit 1
fi

# Get user input for the settings
echo -e "${BBlue}The following disks are available on your system:\n${NC}"
lsblk | grep -v 'rom' | grep -v 'loop'
echo -e "\n"

echo -e "${BBlue}WARNING ALL CURRENT DATA ON THE PARTITION WILL BE LOST.\n${NC}"
read -rp 'Select the target partition. Example sda1 or nvme0n1p1: ' TARGET_PARTITION
echo -e "\n"

cryptsetup luksFormat \
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
cryptsetup --verbose open "/dev/$TARGET_PARTITION" tmpdecrypted
echo -e "\n"

echo -e "${BBlue}Make filesystem $DISK\n${NC}"
mkfs --type ext4 --verbose /dev/mapper/tmpdecrypted
echo -e "\n"

sleep 5

echo -e "${BBlue}Encrypt/close partition \n${NC}"
cryptsetup --verbose close tmpdecrypted
echo -e "${BBlue}Done! \n${NC}"
