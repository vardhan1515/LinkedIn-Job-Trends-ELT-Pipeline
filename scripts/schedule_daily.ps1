param(
  [string]$Time = '02:00'
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $root '..')
$scriptPath = Join-Path $projectRoot 'scripts\daily_run.ps1'

$taskName = 'ELT_Warehouse_Daily'
$cmd = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

schtasks /Create /TN $taskName /TR $cmd /SC DAILY /ST $Time /F | Out-Null

Write-Output "Scheduled task '$taskName' created to run daily at $Time."
