#!/bin/bash

# Bash "stric mode"
set -euo pipefail
FILE_NAME=""
EXISTING_GPG_KEY=""

function usage() {
    cat <<EOF
    Usage: $0 -k EXISTING_GPG_KEY -o FILE_NAME

    -k    The path to the binary key file
    -o    Name of the ASCII armored output file

    Description:
        ASCII armor a binary pgp/gpg key without importing it to your
        keyring
EOF
    exit 1
}

# Parse args
while getopts ":k:o:" opt; do
    case "${opt}" in
        k) EXISTING_GPG_KEY=$OPTARG ;;
        o) FILE_NAME=$OPTARG ;;
        :) echo "Error: -${OPTARG} requires an argument" && usage ;;
        ?) usage ;; # Invalid option
    esac
done
shift $((OPTIND - 1))


if [[ "$EXISTING_GPG_KEY" = /* && -e "$EXISTING_GPG_KEY" ]]; then
    # Do nothing
    :
elif [[ -e "$EXISTING_GPG_KEY" ]]; then
    EXISTING_GPG_KEY="$(pwd)/$EXISTING_GPG_KEY"
else
    echo "Error: Provided keyfile $EXISTING_GPG_KEY does not exist."
    exit 1
fi

gpg \
    --keyring "$EXISTING_GPG_KEY" \
    --no-default-keyring \
    --homedir /dev/null \
    --export \
    --armor \
    --output "$FILE_NAME"
