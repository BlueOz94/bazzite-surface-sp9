#Requires -RunAsAdministrator
param(
  [Parameter(Mandatory = $true)]
  [int]$SizeGB = 350
)

$ErrorActionPreference = 'Stop'
$bytes = $SizeGB * 1GB

Write-Host "Shrinking C: by $SizeGB GB for Bazzite..." -ForegroundColor Cyan
$partition = Get-Partition -DriveLetter C
$max = (Get-PartitionSupportedSize -DriveLetter C).SizeMin
if ($bytes -gt $max) {
  Write-Host "Maximum shrinkable: $([math]::Round($max/1GB,1)) GB" -ForegroundColor Red
  exit 1
}

Resize-Partition -DriveLetter C -Size ($partition.Size - $bytes)
Write-Host "[OK] Unallocated space created. Install Bazzite into free space (do NOT format Windows)." -ForegroundColor Green