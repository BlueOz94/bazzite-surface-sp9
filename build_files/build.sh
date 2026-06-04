#!/bin/bash
# Bazzite + linux-surface for Surface Pro 9 (Intel)
set -eux

# Merge system_files overlay (repo, firstboot unit, scripts)
if [[ -d /ctx/files ]]; then
  find /ctx/files -type f -exec sed -i 's/\r$//' {} +
  cp -a /ctx/files/. /
  chmod +x /usr/libexec/bazzite-surface-firstboot
  systemctl enable bazzite-surface-firstboot.service
fi

SURFACE_REPO="https://pkg.surfacelinux.com/fedora/linux-surface.repo"

dnf5 -y config-manager addrepo --overwrite --from-repofile="${SURFACE_REPO}"

# linux-surface stack for Surface Pro 9 (touch, pen, SAM, cameras)
dnf5 -y install --allowerasing \
  kernel-surface \
  kernel-surface-silverblue \
  iptsd \
  libwacom-surface \
  libcamera \
  surface-secureboot \
  surface-control \
  intel-microcode

systemctl enable iptsd.service || true

dnf5 -y config-manager setopt linux-surface.enabled=0
