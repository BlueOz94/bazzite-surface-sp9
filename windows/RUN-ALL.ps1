#Requires -RunAsAdministrator
$root = Split-Path $PSScriptRoot -Parent
Set-Location $PSScriptRoot

Write-Host "Step 1/4: Windows prep" -ForegroundColor Cyan
& "$PSScriptRoot\Prepare-WindowsForDualBoot.ps1"

Write-Host "`nStep 2/4: Shrink partition (350 GB for Linux)" -ForegroundColor Cyan
$confirm = Read-Host "Shrink C: by 350 GB? [Y/n]"
if ($confirm -ne 'n' -and $confirm -ne 'N') {
  & "$PSScriptRoot\Shrink-WindowsPartition.ps1" -SizeGB 350
}

Write-Host "`nStep 3/4: Download Bazzite ISO" -ForegroundColor Cyan
& "$PSScriptRoot\Download-BazziteISO.ps1"

Write-Host "`nStep 4/4: USB setup" -ForegroundColor Cyan
& "$PSScriptRoot\Create-BazziteUSB.ps1"

Write-Host "`nDone. See $root\INSTALL-SURFACE-PRO-9.md" -ForegroundColor Green