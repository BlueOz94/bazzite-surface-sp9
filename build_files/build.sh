#!/bin/bash
# Surface Pro 9 customizations — follows ublue-os/image-template build.sh pattern
set -ouex pipefail

if [[ -d /ctx/files ]]; then
  find /ctx/files -type f -exec sed -i 's/\r$//' {} + 2>/dev/null || true
  cp -a /ctx/files/. /
  chmod +x /usr/libexec/bazzite-surface-firstboot
  systemctl enable bazzite-surface-firstboot.service || true
fi

# linux-surface repo is shipped in system_files (enabled=0). Enable only for install.
dnf5 -y config-manager setopt linux-surface.enabled=1

SURFACE_PACKAGES=(
  iptsd
  libwacom-surface
  libcamera
  surface-secureboot
)

if dnf5 -y install "${SURFACE_PACKAGES[@]}"; then
  systemctl enable iptsd.service || true
  echo "linux-surface userspace packages installed in image"
else
  echo "WARN: Could not install linux-surface RPMs during image build."
  echo "      Install after boot: scripts/install-surface-stack.sh"
  echo "      (common when Bazzite Fedora release != linux-surface repo)"
fi

dnf5 -y config-manager setopt linux-surface.enabled=0 || true
/ctx/cleanup.sh
