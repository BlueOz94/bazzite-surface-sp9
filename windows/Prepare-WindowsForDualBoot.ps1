#Requires -RunAsAdministrator
<#
  Prepares Surface Pro 9 for dual-boot with Bazzite.
  - Disables Fast Startup (required for clean Linux boot)
  - Disables hibernation file (optional, frees space)
  - Creates system restore point
  - Reports shrinkable partition space (does NOT auto-shrink — run Shrink-WindowsPartition.ps1)
#>
$ErrorActionPreference = 'Stop'

Write-Host "=== Surface Pro 9 — Windows prep for Bazzite ===" -ForegroundColor Cyan

# Fast Startup off
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled -Value 0
Write-Host "[OK] Fast Startup disabled" -ForegroundColor Green

# Disable hibernation (optional, saves disk)
powercfg /hibernate off
Write-Host "[OK] Hibernation disabled" -ForegroundColor Green

# Restore point
try {
  Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue
  Checkpoint-Computer -Description 'Before Bazzite dual-boot' -RestorePointType MODIFY_SETTINGS
  Write-Host "[OK] Restore point created" -ForegroundColor Green
} catch {
  Write-Host "[WARN] Could not create restore point: $_" -ForegroundColor Yellow
}

# BitLocker status
$bl = Get-BitLockerVolume -MountPoint 'C:' -ErrorAction SilentlyContinue
if ($bl -and $bl.ProtectionStatus -eq 'On') {
  Write-Host "[INFO] BitLocker is ON — suspend before install: Suspend-BitLocker -MountPoint C: -RebootCount 1" -ForegroundColor Yellow
}

# Disk space
$os = Get-Partition -DriveLetter C
$vol = Get-Volume -DriveLetter C
$disk = Get-Disk -Number $os.DiskNumber
Write-Host ""
Write-Host "Disk $($disk.FriendlyName) — $($disk.Size / 1GB -as [int]) GB total"
Write-Host "Windows C: — $([math]::Round($vol.SizeRemaining/1GB,1)) GB free of $([math]::Round($vol.Size/1GB,1)) GB"
Write-Host ""
Write-Host "Recommended: allocate 250–400 GB for Bazzite (run Shrink-WindowsPartition.ps1 -SizeGB 350)"
Write-Host "Or shrink manually: diskmgmt.msc"
Write-Host ""
Write-Host "Next: run Download-BazziteISO.ps1 then Create-BazziteUSB.ps1"