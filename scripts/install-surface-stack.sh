#!/bin/bash
# Run on stock Bazzite after install if you did not use the custom image.
set -euo pipefail

NO_MOK=0
for arg in "$@"; do
  case "$arg" in
    --no-mok) NO_MOK=1 ;;
    -h|--help)
      echo "Usage: sudo $0 [--no-mok]"
      echo "  --no-mok   Skip MOK import (use when Secure Boot is off or MOK boot is broken)"
      exit 0
      ;;
  esac
done

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
echo "Packages staged. Reboot to deploy the new deployment (rpm-ostree default)."
echo ""

if command -v mokutil &>/dev/null && mokutil --sb-state 2>/dev/null | grep -qi enabled; then
  if [[ "$NO_MOK" -eq 1 ]]; then
    echo "Secure Boot is ON but --no-mok was set."
    echo "After reboot, kernel-surface may not boot until you enroll keys or disable Secure Boot."
    echo "See FIX-MOK-BOOT.md in this repo."
  else
    echo "Secure Boot is ON."
    if command -v ujust &>/dev/null; then
      echo "  1) Enroll Bazzite key first:  ujust enroll-secure-boot-key"
      echo "     (reboot, MOK screen, password: universalblue)"
    fi
    MOK_DER=""
    for f in /usr/share/surface-secureboot/MOK.der \
             /usr/share/surface-secureboot/MOK.cer \
             /boot/efi/EFI/fedora/mok*.der; do
      [[ -f "$f" ]] && MOK_DER="$f" && break
    done
    if [[ -n "$MOK_DER" ]]; then
      echo "  2) Then enroll Surface key:     sudo mokutil --import $MOK_DER"
      echo "     (pick YOUR password, reboot, Enroll MOK on blue screen)"
    else
      echo "  2) Surface MOK file not found yet; after reboot run:"
      echo "     sudo mokutil --import /usr/share/surface-secureboot/MOK.der"
    fi
    echo ""
    echo "If reboot shows mmx64.efi / import_mok_states errors, read FIX-MOK-BOOT.md"
    echo "Quick fix: disable Secure Boot in UEFI, boot, then fix MOK later."
  fi
else
  echo "Secure Boot is off — no MOK enrollment needed for kernel-surface."
  echo "After reboot:  sudo systemctl enable --now iptsd.service"
fi

echo "Reboot when ready:  systemctl reboot"
if [[ -t 0 ]]; then
  read -r -p "Reboot now? [y/N] " ans
  [[ "${ans,,}" == "y" ]] && systemctl reboot
fi
