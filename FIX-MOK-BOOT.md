# Fix: `mmx64.efi` / MOK Manager / `import_mok_states`

This message means the firmware tried to open **MOK Manager** after a `mokutil --import`, but the EFI boot files are missing or on the wrong path (common on Surface + Ventoy USB, or after a half-finished MOK enroll).

## Fastest fix (recommended for beginners)

**Turn off Secure Boot** so you can boot without MOK enrollment:

1. Shut down the Surface Pro 9.
2. Hold **Volume Down** + press **Power** → UEFI firmware.
3. **Security** → **Secure Boot** → **Off** → Save and exit.
4. Boot **Bazzite** (or the **FEDORA** entry).

`kernel-surface` works with Secure Boot **off** — you do **not** need MOK for touch/pen in that case.

Only turn Secure Boot back on after Bazzite boots normally and you follow the enrollment steps below in order.

---

## If Bazzite is installed but will not boot (black screen / mmx64 error)

Official Bazzite workaround: [Installation Troubleshooting — mmx64.efi](https://docs.bazzite.gg/General/Installation_Guide/troubleshoot_guide/#failed-to-open-efibootmmx64efi-not-found-error)

1. UEFI: **Volume Down** + **Power**.
2. **Boot from file** (or **Boot manager** → pick the **internal** drive, not USB).
3. Open the EFI partition → folder **`EFI/fedora/`**.
4. Select **`grubx64.efi`** (not `mmx64.efi` on the USB).
5. Bazzite should start. Future boots may show **FEDORA** again.

---

## If you are stuck on a pending MOK enroll (after `install-surface-stack.sh`)

You ran `mokutil --import` and rebooted; MOK Manager failed.

### Option A — Boot once via `grubx64.efi` (above), then cancel pending MOK

In a terminal on Bazzite:

```bash
sudo mokutil --list-new    # shows pending enrollments
sudo mokutil --reset       # clears pending requests (may prompt for password)
```

Reboot. With **Secure Boot off**, you should boot without the MOK screen.

### Option B — Complete enrollment correctly (Secure Boot **on**)

1. **Disable Secure Boot** in UEFI (boot once successfully).
2. On Bazzite, enroll **Universal Blue** first (required for Bazzite + SB):

   ```bash
   ujust enroll-secure-boot-key
   ```

   Reboot → blue **MOK Manager** → **Enroll MOK** → password: `universalblue` (QWERTY layout).

   Guide: https://docs.bazzite.gg/General/Installation_Guide/secure_boot/

3. Install Surface stack **without** importing MOK yet if you are unsure:

   ```bash
   sudo bash scripts/install-surface-stack.sh --no-mok
   ```

4. Reboot with **Secure Boot on**. If `kernel-surface` will not boot, then enroll the Surface key **once**:

   ```bash
   sudo mokutil --import /usr/share/surface-secureboot/MOK.der
   ```

   Set a password you will remember → reboot → **Enroll MOK** → enter **that** password (not `universalblue`).

---

## If the error appears on the **USB installer** (live session)

- Prefer **Fedora Media Writer** (writes ISO directly to USB), not Ventoy, for the first install.
- Or in UEFI: **Secure Boot off** for install, then enable later per Bazzite docs.
- Ventoy: pick the ISO → try **GRUB mode** if the screen is black.

---

## Do not do this

- Do not run `mokutil --import` multiple times with different keys before one enroll finishes.
- Do not import MOK from paths on the **USB** (`efi/boot/mmx64.efi` on Ventoy) — that file is for the **installer stick**, not your internal disk.

---

## Still broken?

Boot the Bazzite **installer USB** again → try **Continue boot** on any blue MOK screen → use **Boot from file** → `EFI/fedora/grubx64.efi`.

Support: [linux-surface Matrix](https://matrix.to/#/#linux-surface-support:matrix.org) · [Bazzite troubleshooting](https://docs.bazzite.gg/General/Installation_Guide/troubleshoot_guide/)
