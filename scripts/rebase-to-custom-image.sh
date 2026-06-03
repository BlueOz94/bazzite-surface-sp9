#!/bin/bash
# After pushing this repo to GitHub and building the image:
#   ghcr.io/BlueOz94/bazzite-surface-sp9:stable
set -euo pipefail

OWNER="${1:-BlueOz94}"

IMAGE="ostree-unverified-registry:ghcr.io/${OWNER}/bazzite-surface-sp9:stable"
echo "Rebasing to $IMAGE"
rpm-ostree rebase "$IMAGE"
systemctl reboot