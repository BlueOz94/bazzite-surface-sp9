# Bazzite + linux-surface for Surface Pro 9

Custom [Universal Blue](https://github.com/ublue-os/bazzite) image with [linux-surface](https://github.com/linux-surface/linux-surface) baked in for **Microsoft Surface Pro 9** (Intel i7-1265U, Iris Xe).

## What's included

| Component | Purpose |
|-----------|---------|
| `kernel-surface` | Touch, pen, SAM/KIP, thermal, cameras |
| `iptsd` | Intel Precise Touch multitouch |
| `libwacom-surface` | Surface Pen |
| `libcamera` | Webcam ISP pipeline |
| `surface-secureboot` | MOK key for Secure Boot |
| `surface-control` | Device utilities |

Base image: `ghcr.io/ublue-os/bazzite:stable` (Intel — **not** NVIDIA).

## Quick start (fastest path)

### On Windows (this PC)

Run in **Administrator** PowerShell:

```powershell
cd $env:USERPROFILE\bazzite-surface-sp9\windows
.\Prepare-WindowsForDualBoot.ps1
.\Shrink-WindowsPartition.ps1 -SizeGB 350   # optional
.\Download-BazziteISO.ps1
.\Create-BazziteUSB.ps1
```

### Install Bazzite from USB

1. [download.bazzite.gg](https://download.bazzite.gg/) — **Bazzite Desktop**, not NVIDIA/Deck
2. Dual-boot into unallocated space
3. Surface tip: Ventoy **GRUB mode** if live session black-screens

### After first boot (pick one)

**A — Custom image** (after GitHub Actions build completes):

```bash
./scripts/rebase-to-custom-image.sh BlueOz94
# Image: ghcr.io/blueoz94/bazzite-surface-sp9:stable
```

**B — Stock Bazzite + script** (works immediately):

```bash
sudo ./scripts/install-surface-stack.sh
```

## Build your own image (official uBlue way)

This repo follows [ublue-os/image-template](https://github.com/ublue-os/image-template): **FROM** `ghcr.io/ublue-os/bazzite:stable`, customize in `build_files/build.sh`, CI publishes to GHCR. You do **not** need to fork Bazzite itself.

See **[BUILD-YOUR-OWN.md](./BUILD-YOUR-OWN.md)** for setup, cosign, and `bootc switch`.

1. Repo: https://github.com/BlueOz94/bazzite-surface-sp9
2. Actions → **Build Bazzite Surface SP9 image** (wait ~30–60 min; do not push several commits in a row)
3. Image: `ghcr.io/blueoz94/bazzite-surface-sp9:stable`

## Device profile

Hardware inventory: `../surface-pro9-device-profile.json`

## Links

- [linux-surface wiki](https://github.com/linux-surface/linux-surface/wiki)
- [Bazzite docs](https://docs.bazzite.gg/)
- [SP9 feature matrix](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features)
