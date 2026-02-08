param(
  [string]$Date
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $root '..')
$dailyDir = Join-Path $projectRoot 'data\daily'
$sourceFile = Join-Path $projectRoot 'data\source\postings.csv'

# Ensure Postgres is up
try {
  docker compose -f (Join-Path $projectRoot 'docker-compose.yml') up -d | Out-Null
} catch {
  # If docker isn't available, continue; ingestion will fail with a clear error
}

# Regenerate daily batches (idempotent)
python (Join-Path $projectRoot 'scripts\split_daily.py') --input $sourceFile --output-dir $dailyDir

if (-not $Date) {
  # Use today's date if file exists, else latest file
  $today = (Get-Date).ToString('yyyy-MM-dd')
  $todayPath = Join-Path $dailyDir ("$today.csv")
  if (Test-Path $todayPath) {
    $Date = $today
  } else {
    $latest = Get-ChildItem -Path $dailyDir -Filter *.csv | Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latest) { throw "No daily CSV files found in $dailyDir" }
    $Date = [System.IO.Path]::GetFileNameWithoutExtension($latest.Name)
  }
}

$csvPath = Join-Path $dailyDir ("$Date.csv")
if (-not (Test-Path $csvPath)) { throw "Daily CSV not found: $csvPath" }

python (Join-Path $projectRoot 'scripts\ingest_daily.py') --csv $csvPath --load-date $Date
python (Join-Path $projectRoot 'scripts\materialize_stg.py')

$env:DBT_PROFILES_DIR = (Join-Path $projectRoot 'dbt_job_warehouse')
Push-Location (Join-Path $projectRoot 'dbt_job_warehouse')
try {
  python -m dbt.cli.main build --exclude stg_job_postings
  python -m dbt.cli.main docs generate
} finally {
  Pop-Location
}
