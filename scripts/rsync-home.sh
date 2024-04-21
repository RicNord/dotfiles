#!/bin/bash

# Backups the home directory to a specified target directory
# Files will be filtered based on $HOME/.rsync-home.filter

HOSTNAME="$(hostname)"

TARGET_DIR="${1:-/mnt/usb/$HOSTNAME}"

rsync \
    --verbose \
    --archive \
    --human-readable \
    --progress \
    --delete \
    --filter="merge $HOME/.rsync-home.filter" \
    "$HOME/" \
    "$TARGET_DIR"
