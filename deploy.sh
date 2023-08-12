#!/bin/bash

# Deployment script for dotfiles
# This .sh file must be located in the same base directory as the dotfiles.

# Bash "stric mode"
set -euo pipefail

FORCE_DEPLOY=false
ETC_DEPLOY=false
VERBOSE_EXEC=false
FILE_DIFF=""
REPO_ROOT="$(dirname "$0")"

# Set newline as separator
IFS=$'\n'

function usage() {
    cat <<EOF
    Usage: $0 [ -f ] [ -e ] [ -v ] [ DOTFILE(S) ]

    -f    Force deployment without validation of changes
    -e    Deploy user system config files to etc/... (Must run as root)
    -v    Verbose mode

EOF
    exit 1
}

# Parse args
while getopts ":fev" opt; do
    case "${opt}" in
        f) FORCE_DEPLOY=true ;;
        e) ETC_DEPLOY=true ;;
        v) VERBOSE_EXEC=true ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

function set_base_path() {
    if [[ $1 == etc/* ]]; then
        FILE_BASE_PATH="/"
    else
        FILE_BASE_PATH="$HOME/"
    fi
}

function diff_and_deploy() {
    # Arg 1 = path to file
    set_base_path "$1"
    if [ -f "${FILE_BASE_PATH}""$1" ]; then

        FILE_DIFF=$(diff --color=always "${FILE_BASE_PATH}$1" "${REPO_ROOT}/$1" || true)

        if [ "$FILE_DIFF" != "" ] && [ $FORCE_DEPLOY = false ]; then
            echo "-----------------"
            echo "$1 Diff"
            echo "-----------------"
            echo "$FILE_DIFF"

        elif [ "$FILE_DIFF" = "" ] && [ $VERBOSE_EXEC = true ]; then
            echo "$1 | SKIPPING, no changes found"
        fi

        if [ "$FILE_DIFF" != "" ] && [ $FORCE_DEPLOY != true ]; then
            read -rp "Apply changes? (y/n)[y]: " confirm
            confirm=${confirm:-y}
            [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

            [ $VERBOSE_EXEC = true ] && echo "$1 | WRITING changes to target"
            deploy_dotfile "$1"

        elif [ "$FILE_DIFF" != "" ] && [ $FORCE_DEPLOY = true ]; then
            deploy_dotfile "$1"

        fi
    else
        [ $VERBOSE_EXEC = true ] && echo "$1 | WRITING, file did not exist in target"
        deploy_dotfile "$1"

    fi
}

function deploy_dotfile() {
    mkdir -p -- "$(dirname -- "${FILE_BASE_PATH}$1")"
    cp "${REPO_ROOT}/$1" "${FILE_BASE_PATH}$1"
}

function main() {
    [[ $ETC_DEPLOY = false ]] && [[ $VERBOSE_EXEC = true ]] && echo "Deploy $HOME/... files"
    [[ $ETC_DEPLOY = true ]] && [[ $VERBOSE_EXEC = true ]] && echo "Deploy /etc/... files"

    if [ "$#" -eq 0 ]; then
        FILES_FOR_DEPLOYMENT=$(find "$REPO_ROOT/" \
            -type f \
            -not -path '*/.git/*' \
            -not -name 'deploy.sh' \
            -not -name 'README.md' \
            -not -name 'LICENSE' \
            -printf "%P\n" \
            | sort)
        [ $VERBOSE_EXEC = true ] && echo -e \
            "\n----Detected files---- \n\n$FILES_FOR_DEPLOYMENT\n\n ----End detected files----\n"

        for arg in $FILES_FOR_DEPLOYMENT; do
            [[ "$arg" == etc/* ]] && [[ $ETC_DEPLOY = false ]] && continue
            [[ "$arg" != etc/* ]] && [[ $ETC_DEPLOY = true ]] && continue
            diff_and_deploy "$arg"
        done
    else
        for arg in "$@"; do
            diff_and_deploy "$arg"
        done
    fi
}

main "$@"
