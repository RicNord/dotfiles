#!/bin/bash
# Downloads and verifies the latest arch iso
# Dependencies: wget, sequoia-sq

mkdir -p /tmp/arch-iso

# Download iso
printf '%s\n' "---------------"
printf '%s\n' "Downlad arch iso"
printf '%s\n' "---------------"
wget -r -O /tmp/arch-iso/archlinux-x86_64.iso https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso
# Donwload sig
printf '%s\n' "---------------"
printf '%s\n' "Downlad arch iso.sig"
printf '%s\n' "---------------"
wget -r -O /tmp/arch-iso/archlinux-x86_64.iso.sig https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso.sig
# Download release signing key
printf '%s\n' "---------------"
printf '%s\n' "get release signature"
printf '%s\n' "---------------"
sq --force wkd get pierre@archlinux.org -o /tmp/arch-iso/release-key.pgp
# Verify key
printf '%s\n' "---------------"
printf '%s\n' "Check signature"
printf '%s\n' "---------------"
sq verify --signer-file /tmp/arch-iso/release-key.pgp --detached /tmp/arch-iso/archlinux-x86_64.iso.sig /tmp/arch-iso/archlinux-x86_64.iso
