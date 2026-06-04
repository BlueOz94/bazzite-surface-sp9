# Surface Pro 9 — USB install (Rufus vs Fedora Media Writer)

## Your Rufus log — what went wrong

| What Rufus shows | Problem for Surface Pro 9 |
|------------------|---------------------------|
| `bazzite-deck-gnome-stable-live-amd64.iso` | **Wrong image** — Deck is for handhelds/Steam Deck UI, not your Intel tablet desktop |
| `WARNING: FAT32 has been forcefully enabled...` | Can break hybrid Bazzite USB boot |
| `DD image mode enforced` | OK for this ISO — keep **DD Image** (not ISO mode) |
| `mmx64.efi` on `/EFI/fedora/` | Normal on the stick; MOK errors happen if Secure Boot + wrong boot path |

**Use:** `bazzite-*-desktop-*-live-amd64.iso` (or pick **Bazzite Desktop** at https://download.bazzite.gg/)  
**Do not use:** `deck`, `nvidia`, or `deck-gnome` in the filename.

---

## Recommended: Fedora Media Writer (not Rufus)

1. Install: `winget install Fedora.FedoraMediaWriter`
2. Open **Fedora Media Writer** → **Custom image** or https://download.bazzite.gg/
3. Choose **Bazzite** → **Desktop** (KDE or GNOME desktop — **not** Deck, **not** NVIDIA)
4. Select your **SanDisk 14.9 GB** USB → **Write**
5. UEFI: **Secure Boot OFF** for install (can enable later)

---

## If you insist on Rufus 4.14

1. **Download the correct ISO** from https://download.bazzite.gg/  
   - Name should look like `bazzite-gnome-*-stable-live-amd64.iso` or `bazzite-*-desktop-*`  
   - **No** `deck` in the name

2. **Rufus settings**
   - Device: SanDisk Cruzer Blade (14.9 GB)
   - Partition: **GPT**
   - Target: **UEFI (non CSM)**
   - Image mode: **DD Image** (Rufus will force this — correct)
   - File system: if Rufus warns about FAT32, prefer defaults that match **DD**; do not switch to a broken FAT32-only layout

3. **Close** Explorer windows on the USB, run Rufus **as Administrator**

4. **Boot Surface**
   - Volume Down + Power → UEFI
   - **Secure Boot: Disabled**
   - Boot USB → if blue MOK screen: **Continue boot**
   - If `mmx64.efi` error: see [FIX-MOK-BOOT.md](./FIX-MOK-BOOT.md)

---

## After install

```bash
curl -fsSL https://raw.githubusercontent.com/BlueOz94/bazzite-surface-sp9/main/scripts/install-surface-stack.sh | sudo bash
```

With Secure Boot **off**, skip MOK enrollment until you read [FIX-MOK-BOOT.md](./FIX-MOK-BOOT.md).
