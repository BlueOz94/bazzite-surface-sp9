#Requires -RunAsAdministrator
<#
  Installs Ventoy on USB and copies Bazzite ISO (Surface-friendly GRUB boot).
#>
param(
  [string]$UsbDriveLetter = '',
  [string]$IsoPath = "$env:USERPROFILE\Downloads\Bazzite\bazzite-stable-desktop.iso"
)

$ErrorActionPreference = 'Stop'

if (-not $UsbDriveLetter) {
  Write-Host "Removable drives:" -ForegroundColor Cyan
  Get-Disk | Where-Object BusType -eq 'USB' | Format-Table Number, FriendlyName, Size, PartitionStyle
  $UsbDriveLetter = Read-Host "Enter USB drive NUMBER (from Disk Number column, e.g. 2)"
}

# Install Ventoy
if (-not (Get-Command ventoy2disk -ErrorAction SilentlyContinue)) {
  winget install --id Ventoy.Ventoy -e --accept-package-agreements --accept-source-agreements
}

$ventoy = "${env:ProgramFiles}\Ventoy\Ventoy2Disk.exe"
if (-not (Test-Path $ventoy)) {
  $ventoy = Get-ChildItem -Path "${env:ProgramFiles*}\Ventoy" -Filter Ventoy2Disk.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
}

Write-Host @"
=== Ventoy USB for Surface Pro 9 ===
1. Run Ventoy2Disk as Administrator: $ventoy
2. Select USB disk $UsbDriveLetter, install Ventoy (GPT, default options)
3. Copy ISO to the Ventoy partition:

"@

if (Test-Path $IsoPath) {
  $vol = Get-Volume | Where-Object { $_.FileSystemLabel -eq 'Ventoy' -or $_.DriveLetter -match '^[D-Z]$' } | Select-Object -First 1
  if ($vol) {
    $dest = "$($vol.DriveLetter):\$([IO.Path]::GetFileName($IsoPath))"
    Copy-Item -Path $IsoPath -Destination $dest -Force
    Write-Host "[OK] Copied ISO to $dest" -ForegroundColor Green
  } else {
    Write-Host "Copy manually: $IsoPath -> Ventoy USB root" -ForegroundColor Yellow
  }
} else {
  Write-Host "ISO not found at $IsoPath — run Download-BazziteISO.ps1 first" -ForegroundColor Yellow
}

Write-Host @"

Boot Surface Pro 9:
  Hold Volume Down + Power -> UEFI -> boot USB
  In Ventoy: select ISO -> GRUB mode if normal boot black-screens

Install: dual-boot, keep Windows on C:, use free/unallocated space for Bazzite.

After install (stock Bazzite), copy scripts/install-surface-stack.sh and run it.
Or push this repo to GitHub, build image, rebase with scripts/rebase-to-custom-image.sh

"@ -ForegroundColor Cyan