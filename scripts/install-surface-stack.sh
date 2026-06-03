#!/bin/bash
# Run on stock Bazzite after install if you did not use the custom image.
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run: sudo $0"
  exit 1
fi

SURFACE_REPO="https://pkg.surfacelinux.com/fedora/linux-surface.repo"
curl -fsSL "$SURFACE_REPO" -o /etc/yum.repos.d/linux-surface.repo

rpm-ostree install --allow-inactive --idempotent \
  kernel-surface \
  kernel-surface-silverblue \
  iptsd \
  libwacom-surface \
  libcamera \
  libcamera-tools \
  surface-secureboot \
  surface-control

echo ""
echo "Installed. Reboot, then enroll MOK if Secure Boot is on:"
echo "  sudo mokutil --import /boot/efi/EFI/fedora/mok*.der  # or follow surface-secureboot prompts"
echo "  systemctl enable --now iptsd.service"
systemctl reboot