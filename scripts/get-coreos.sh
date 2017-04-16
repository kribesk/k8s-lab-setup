#!/bin/bash
# USAGE: ./scripts/get-coreos
# USAGE: ./scripts/get-coreos channel version dest
set -eou pipefail

GPG=${GPG:-/usr/bin/gpg}

CHANNEL=${1:-"stable"}
VERSION=${2:-"1235.9.0"}
DEST=/vagrant/coreos/$VERSION
BASE_URL=https://$CHANNEL.release.core-os.net/amd64-usr/$VERSION

# check channel/version exist based on the header response
if ! curl -s -I $BASE_URL/coreos_production_pxe.vmlinuz | grep -q -E '^HTTP/[0-9.]+ [23][0-9][0-9]' ; then
  echo "Channel or Version not found"
  exit 1
fi

if [ ! -d "$DEST" ]; then
  echo "Creating directory $DEST"
  mkdir -p $DEST
fi

echo "Downloading CoreOS $CHANNEL $VERSION images and sigs to $DEST"

echo "CoreOS Image Signing Key"
curl -# https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.asc -o $DEST/CoreOS_Image_Signing_Key.asc
$GPG --import < "$DEST/CoreOS_Image_Signing_Key.asc" || true

# PXE kernel and sig
echo "coreos_production_pxe.vmlinuz..."
curl -# $BASE_URL/coreos_production_pxe.vmlinuz -o $DEST/coreos_production_pxe.vmlinuz
echo "coreos_production_pxe.vmlinuz.sig"
curl -# $BASE_URL/coreos_production_pxe.vmlinuz.sig -o $DEST/coreos_production_pxe.vmlinuz.sig

# PXE initrd and sig
echo "coreos_production_pxe_image.cpio.gz"
curl -# $BASE_URL/coreos_production_pxe_image.cpio.gz -o $DEST/coreos_production_pxe_image.cpio.gz
echo "coreos_production_pxe_image.cpio.gz.sig"
curl -# $BASE_URL/coreos_production_pxe_image.cpio.gz.sig -o $DEST/coreos_production_pxe_image.cpio.gz.sig

# Install image
echo "coreos_production_image.bin.bz2"
curl -# $BASE_URL/coreos_production_image.bin.bz2 -o $DEST/coreos_production_image.bin.bz2
echo "coreos_production_image.bin.bz2.sig"
curl -# $BASE_URL/coreos_production_image.bin.bz2.sig -o $DEST/coreos_production_image.bin.bz2.sig

# verify signatures
$GPG --verify $DEST/coreos_production_pxe.vmlinuz.sig
$GPG --verify $DEST/coreos_production_pxe_image.cpio.gz.sig
$GPG --verify $DEST/coreos_production_image.bin.bz2.sig
