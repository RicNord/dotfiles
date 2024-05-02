#!/bin/bash

# Backups the home directory to a specified target directory
# Files will be filtered based on $HOME/.rsync-home.filter

# Bash stric mode + x debug
set -euxo pipefail

HOSTNAME="$(hostname)"

REVERSE=false
GO=false
VERBOSE=false

function usage() {
    cat <<EOF
    Usage: $0 [ -r ] [ -g ] [ -v ] [ TARGET_DIR ]

    -r    Reverse, rsync to HOME dir
    -g    GO! No dry-run
    -v    Verbose

EOF
    exit 1
}

# Parse args
while getopts ":rgv" opt; do
    case "${opt}" in
        r) REVERSE=true ;;
        g) GO=true ;;
        v) VERBOSE=true ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

TARGET_DIR="${1:-/mnt/usb/$HOSTNAME}"

# Build up args
args=()

# Check for GO arg
[ "$GO" != true ] && args+=('--dry-run')
# Check for Verbose arg
[ "$VERBOSE" == true ] && args+=('--verbose')

if [ "$REVERSE" == false ]; then
    rsync \
        "${args[@]}" \
        --archive \
        --human-readable \
        --progress \
        --delete \
        --filter="merge $HOME/.rsync-home.filter" \
        "$HOME/" \
        "$TARGET_DIR"

else
    rsync \
        "${args[@]}" \
        --archive \
        --human-readable \
        --progress \
        "$TARGET_DIR/" \
        "$HOME"
fi
