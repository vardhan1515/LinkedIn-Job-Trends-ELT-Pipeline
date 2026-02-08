param(
    [string]$Date,
    [switch]$SkipSplit,
    [switch]$SkipDbt,
    [switch]$SkipDb
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $root '..')
$dailyDir = Join-Path $projectRoot 'data\daily'
$sourceFile = Join-Path $projectRoot 'data\source\postings.csv'

if (-not $SkipDb) {
    docker compose -f (Join-Path $projectRoot 'docker-compose.yml') up -d
}

if (-not $SkipSplit) {
    python (Join-Path $projectRoot 'scripts\split_daily.py') --input $sourceFile --output-dir $dailyDir
}

if (-not $Date) {
    $latest = Get-ChildItem -Path $dailyDir -Filter *.csv | Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latest) { throw "No daily CSV files found in $dailyDir" }
    $Date = [System.IO.Path]::GetFileNameWithoutExtension($latest.Name)
}

$csvPath = Join-Path $dailyDir ("$Date.csv")
if (-not (Test-Path $csvPath)) { throw "Daily CSV not found: $csvPath" }

python (Join-Path $projectRoot 'scripts\ingest_daily.py') --csv $csvPath --load-date $Date
python (Join-Path $projectRoot 'scripts\materialize_stg.py')

if (-not $SkipDbt) {
    $env:DBT_PROFILES_DIR = (Join-Path $projectRoot 'dbt_job_warehouse')
    Push-Location (Join-Path $projectRoot 'dbt_job_warehouse')
    try {
        python -m dbt.cli.main build --exclude stg_job_postings
        python -m dbt.cli.main docs generate
    } finally {
        Pop-Location
    }
}
