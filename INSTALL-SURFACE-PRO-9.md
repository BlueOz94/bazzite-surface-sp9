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

Secure Boot / MOK (only if Secure Boot is **on** in UEFI):

1. Enroll Bazzite first: `ujust enroll-secure-boot-key` → reboot → blue screen → **Enroll MOK** → password `universalblue`
2. Then Surface key: `sudo mokutil --import /usr/share/surface-secureboot/MOK.der` → reboot → **Enroll MOK** → **your** password
3. `sudo systemctl enable --now iptsd.service`

**Easier:** turn **Secure Boot off** in UEFI — skip all MOK steps; touch/pen still work.

If you see **`mmx64.efi` / `import_mok_states`**: see **[FIX-MOK-BOOT.md](./FIX-MOK-BOOT.md)** (boot `EFI/fedora/grubx64.efi` from UEFI).

## Phase 4 — Verify

```bash
uname -r          # should contain 'surface'
systemctl status iptsd
libcamera-hello --list-cameras   # if cameras needed
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `mmx64.efi` / MOK / `import_mok_states` | [FIX-MOK-BOOT.md](./FIX-MOK-BOOT.md) — disable Secure Boot or boot `grubx64.efi` |
| Black screen live USB | Ventoy GRUB mode; prefer Fedora Media Writer for install USB |
| No touch | `sudo systemctl restart iptsd` ; check `kernel-surface` booted |
| Pen pressure | `libwacom-surface`, calibrate in KDE settings |
| Cameras | libcamera; see linux-surface wiki for ISP status |
| TLP lag | Do not install TLP on Surface |

Support: [linux-surface Matrix](https://matrix.to/#/#linux-surface-support:matrix.org)
