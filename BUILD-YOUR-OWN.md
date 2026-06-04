# Build your own Bazzite (official path)

Bazzite is a **bootc OCI image**. You do not need to fork [ublue-os/bazzite](https://github.com/ublue-os/bazzite) to add Surface drivers — you **derive from** their published image, which is what this repo does.

## How this repo maps to uBlue docs

| Bazzite / uBlue guidance | This project |
|--------------------------|--------------|
| [image-template](https://github.com/ublue-os/image-template) | Same layout: `Containerfile`, `build_files/build.sh`, GitHub Actions → GHCR |
| Base image `FROM ghcr.io/ublue-os/bazzite:stable` | Yes — Intel SP9 (not `bazzite-nvidia`) |
| Weekly rebuilds | Workflow cron: Mondays 08:40 UTC |
| Cosign signing | Optional `SIGNING_SECRET` repo secret |
| Fork Bazzite + Pull app | Only if you change **Bazzite itself**; not required for a **custom layer** like this |

## One-time GitHub setup

1. Enable **Actions** on https://github.com/BlueOz94/bazzite-surface-sp9
2. (Optional) Sign images:
   ```bash
   COSIGN_PASSWORD="" cosign generate-key-pair
   ```
   Add `cosign.key` contents as repo secret **`SIGNING_SECRET`**, commit **`cosign.pub`** only.
3. Push to `main` → workflow **Build Bazzite Surface SP9 image** (~30–60 min)
4. Package: `ghcr.io/blueoz94/bazzite-surface-sp9:stable`

## Use the image on the tablet

After stock Bazzite is installed:

```bash
sudo bootc switch ghcr.io/blueoz94/bazzite-surface-sp9:stable
systemctl reboot
```

Or stay on stock Bazzite and run the post-install script (always works):

```bash
curl -fsSL https://raw.githubusercontent.com/BlueOz94/bazzite-surface-sp9/main/scripts/install-surface-stack.sh | sudo bash
```

`kernel-surface` is applied on the device via `rpm-ostree` (not always baked into the OCI build when Fedora versions differ).

## Stay in sync with upstream Bazzite

- **Image updates**: Rebuilds pull latest `ghcr.io/ublue-os/bazzite:stable` each CI run.
- **Fork + Pull app**: Use only if you maintain a fork of the Bazzite *source* repo, not this Surface overlay.

## Links

- [image-template README](https://github.com/ublue-os/image-template)
- [Bazzite docs — custom images](https://docs.bazzite.gg/)
- [linux-surface wiki](https://github.com/linux-surface/linux-surface/wiki)
