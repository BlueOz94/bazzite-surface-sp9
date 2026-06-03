# Downloads official Bazzite Desktop (Intel) ISO via Fedora Media Writer API / direct mirror
$ErrorActionPreference = 'Stop'
$outDir = Join-Path $env:USERPROFILE 'Downloads\Bazzite'
$null = New-Item -ItemType Directory -Force -Path $outDir

# Bazzite image picker — stable desktop KDE (Intel, not NVIDIA)
# Direct ISO URLs rotate; use Fedora Media Writer for reliability
$isoPath = Join-Path $outDir 'bazzite-stable-desktop.iso'

Write-Host "=== Bazzite ISO download ===" -ForegroundColor Cyan
Write-Host "Official picker: https://download.bazzite.gg/"
Write-Host "Target folder:   $outDir"
Write-Host ""

# Try Fedora Media Writer flatpak/winget install
if (-not (Get-Command 'mediawriter' -ErrorAction SilentlyContinue)) {
  Write-Host "Installing Fedora Media Writer (recommended for Surface)..." -ForegroundColor Yellow
  winget install --id Fedora.FedoraMediaWriter -e --accept-package-agreements --accept-source-agreements
}

Write-Host @"

MANUAL STEPS (most reliable on Surface):
1. Open Fedora Media Writer (Start menu)
2. Click 'Custom image' or visit https://download.bazzite.gg/
3. Select: Bazzite (Desktop) — NOT NVIDIA, NOT Deck
4. Write to USB (8GB+)

Surface boot tip: If live USB black-screens after GRUB, use Ventoy GRUB mode.

"@ -ForegroundColor Green

# Attempt to fetch latest ISO list from GitHub releases (installer assets)
try {
  $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/ublue-os/bazzite/releases/latest' -Headers @{ 'User-Agent' = 'bazzite-surface-sp9' }
  $assets = $releases.assets | Where-Object { $_.name -match '\.iso$' -and $_.name -notmatch 'nvidia|deck|gnome' }
  if ($assets) {
    Write-Host "Found ISO assets on GitHub release:" -ForegroundColor Cyan
    $assets | ForEach-Object { Write-Host "  $($_.name) - $($_.browser_download_url)" }
    $pick = $assets | Select-Object -First 1
    Write-Host "Downloading $($pick.name) ..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $pick.browser_download_url -OutFile $isoPath -UseBasicParsing
    Write-Host "[OK] Saved: $isoPath" -ForegroundColor Green
    exit 0
  }
} catch {
  Write-Host "[INFO] No direct ISO in GitHub release; use Fedora Media Writer." -ForegroundColor Yellow
}

Write-Host "No ISO auto-downloaded. Use Fedora Media Writer + https://download.bazzite.gg/" -ForegroundColor Yellow