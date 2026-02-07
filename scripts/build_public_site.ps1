$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $root '..')

$env:DBT_PROFILES_DIR = (Join-Path $projectRoot 'dbt_job_warehouse')
Push-Location (Join-Path $projectRoot 'dbt_job_warehouse')
try {
  python -m dbt.cli.main build
  python -m dbt.cli.main docs generate
} finally {
  Pop-Location
}

python (Join-Path $projectRoot 'scripts\export_dashboard_data.py')

$target = Join-Path $projectRoot 'dbt_job_warehouse\target'
$publicDocs = Join-Path $projectRoot 'public\dbt-docs'

New-Item -ItemType Directory -Force -Path $publicDocs | Out-Null
Copy-Item -Recurse -Force -Path (Join-Path $target '*') -Destination $publicDocs

Write-Output "Public site ready in $projectRoot\public"
