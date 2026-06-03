# Surface Pro 9 — full install checklist

## Phase 1 — Windows (done by scripts in `windows/`)

- [x] Device profile captured
- [ ] Fast Startup disabled — `Prepare-WindowsForDualBoot.ps1`
- [ ] 250–400 GB unallocated — `Shrink-WindowsPartition.ps1 -SizeGB 350`
- [ ] Bazzite ISO on USB — `Download-BazziteISO.ps1` + `Create-BazziteUSB.ps1`
- [ ] BitLocker suspended if enabled: `Suspend-BitLocker -MountPoint C: -RebootCount 1`

## Phase 2 — Install

1. Boot: Volume Down + Power → USB
2. Ventoy → Bazzite ISO → **GRUB mode** if black screen
3. Installer: **dual boot**, install to **free space** only
4. User account + encryption if desired (see linux-surface disk encryption wiki)

## Phase 3 — Surface drivers

```bash
# Option A: post-install on stock Bazzite
sudo bash /path/to/install-surface-stack.sh

# Option B: custom image from GHCR
bash rebase-to-custom-image.sh YOUR_GITHUB_USER
```

After reboot with Secure Boot:

```bash
sudo mokutil --import /usr/share/surface-secureboot/MOK.der
# password you set during enroll; then reboot
sudo systemctl enable --now iptsd.service
```

## Phase 4 — Verify

```bash
uname -r          # should contain 'surface'
systemctl status iptsd
libcamera-hello --list-cameras   # if cameras needed
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Black screen live USB | Ventoy GRUB mode; nomodeset not usually needed on SP9 |
| No touch | `sudo systemctl restart iptsd` ; check `kernel-surface` booted |
| Pen pressure | `libwacom-surface`, calibrate in KDE settings |
| Cameras | libcamera; see linux-surface wiki for ISP status |
| TLP lag | Do not install TLP on Surface |

Support: [linux-surface Matrix](https://matrix.to/#/#linux-surface-support:matrix.org)