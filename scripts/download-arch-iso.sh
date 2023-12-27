#!/bin/bash
# Downloads and verifies the latest arch iso
# Optionally copies the image to a device or wipes a device for restoration
# Dependencies: wget, sequoia-sq
#
# Bash "stric mode"
set -euo pipefail
STORAGE_DEV=""
WHIPE_DEVICE=""

function usage() {
    cat <<EOF
    Usage: $0 [ -c /dev/<device>]

    -c    [ /dev/path ] Copy iso to storage device
    -w    [ /dev/path ] Wipe the storage device and restore

    Note: 
        Path to device should not include the partition number.
        Example: 
            Valid: /dev/sda 
            NOT valid: /dev/sda1
EOF
    exit 1
}

# Parse args
while getopts ":c:w:" opt; do
    case "${opt}" in
        c) STORAGE_DEV=$OPTARG ;;
        w) WHIPE_DEVICE=$OPTARG ;;
        :) echo "Error: -${OPTARG} requires a path to device" ;;
        ?) usage ;;
    esac
done
shift $((OPTIND - 1))

if [ "$WHIPE_DEVICE" != "" ] && [ -b "$WHIPE_DEVICE" ]; then
    printf '%s\n' "---------------"
    printf '%s\n' "Whipe device $WHIPE_DEVICE"
    printf '%s\n' "---------------"
    sudo wipefs --all "$WHIPE_DEVICE"
    exit 0
elif [ "$WHIPE_DEVICE" != "" ] && [ ! -b "$WHIPE_DEVICE" ]; then
    printf '%s\n' "---------------"
    printf '%s\n' "EXIT 1: Invalid path for WHIPE_DEVICE $WHIPE_DEVICE"
    printf '%s\n' "---------------"
    exit 1
fi

mkdir -p /tmp/arch-iso

printf '%s\n' "---------------"
printf '%s\n' "Downlad arch iso"
printf '%s\n' "---------------"
wget -r -O /tmp/arch-iso/archlinux-x86_64.iso -c https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso

printf '%s\n' "---------------"
printf '%s\n' "Downlad arch iso.sig"
printf '%s\n' "---------------"
wget -r -O /tmp/arch-iso/archlinux-x86_64.iso.sig https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso.sig

printf '%s\n' "---------------"
printf '%s\n' "get release signature"
printf '%s\n' "---------------"
sq --force wkd get pierre@archlinux.org -o /tmp/arch-iso/release-key.pgp

printf '%s\n' "---------------"
printf '%s\n' "Check signature"
printf '%s\n' "---------------"
sq verify --signer-file /tmp/arch-iso/release-key.pgp --detached /tmp/arch-iso/archlinux-x86_64.iso.sig /tmp/arch-iso/archlinux-x86_64.iso

if [ "$STORAGE_DEV" != "" ] && [ -b "$STORAGE_DEV" ]; then
    printf '%s\n' "---------------"
    printf '%s\n' "Copy iso to $STORAGE_DEV"
    printf '%s\n' "---------------"
    sudo dd bs=4M if=/tmp/arch-iso/archlinux-x86_64.iso of="$STORAGE_DEV" conv=fsync oflag=direct status=progress
    exit 0
elif [ "$STORAGE_DEV" != "" ] && [ ! -b "$STORAGE_DEV" ]; then
    printf '%s\n' "---------------"
    printf '%s\n' "EXIT 1: Invalid path for STORAGE_DEV $STORAGE_DEV"
    printf '%s\n' "---------------"
    exit 1
fi

exit 0
