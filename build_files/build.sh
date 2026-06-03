#!/bin/bash
# Bazzite + linux-surface for Surface Pro 9 (Intel)
set -ouex pipefail

# Merge system_files overlay (repo, firstboot unit, scripts)
if [[ -d /ctx/files ]]; then
  cp -a /ctx/files/. /
  chmod +x /usr/libexec/bazzite-surface-firstboot
  systemctl enable bazzite-surface-firstboot.service
fi

SURFACE_REPO="https://pkg.surfacelinux.com/fedora/linux-surface.repo"

dnf5 -y config-manager addrepo --overwrite --from-repofile="${SURFACE_REPO}"

# Replace Bazzite gaming kernel with linux-surface kernel + SP9 touch/pen/camera stack
dnf5 -y install --allowerasing \
  kernel-surface \
  kernel-surface-silverblue \
  kernel-surface-devel \
  iptsd \
  libwacom-surface \
  libcamera \
  libcamera-tools \
  surface-secureboot \
  surface-control \
  intel-microcode

# Enable touch daemon for Intel PTS (Surface Pro 8/9+)
systemctl enable iptsd.service || true

# Disable surface repo in final image so updates use layered ostree + manual rebase
dnf5 -y config-manager setopt linux-surface.enabled=0