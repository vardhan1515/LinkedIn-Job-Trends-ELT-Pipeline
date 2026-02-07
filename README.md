# ELT Warehouse - LinkedIn Job Market Analytics

## Overview
This project ingests daily job-posting CSV batches into Postgres, transforms them with dbt, and builds analytics-ready marts.

## Quick Start
1. Install Python deps:

```powershell
pip install -r requirements.txt
```

2. Start the database:

```powershell
docker compose up -d
```

3. Split raw file into daily batches:

```powershell
python scripts\split_daily.py
```

4. Ingest one day and run dbt:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\run_all.ps1 -Date 2024-04-20
```

If you omit `-Date`, the script uses the latest daily file.

## dbt
The dbt project lives in `dbt_job_warehouse`. To run manually:

```powershell
$env:DBT_PROFILES_DIR = (Resolve-Path dbt_job_warehouse)
dbt build
```

## Schemas
- `raw.raw_job_postings` (append-only raw ingestion)
- `staging` (cleaned views)
- `analytics` (dimensions + fact)
- `marts` (final analytics tables)
## Live (Local Scheduler)
To run the pipeline automatically every day on this machine:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\schedule_daily.ps1 -Time 02:00
```

This creates a Windows Task Scheduler job that runs `scripts\daily_run.ps1` daily.

To run once immediately:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\daily_run.ps1
```
## Public Deploy (Static)
To generate a static site (dashboard + dbt docs) in `public/`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build_public_site.ps1
```

Open locally:

```powershell
start public\index.html
```

To publish, upload the `public/` folder to any static host (GitHub Pages, Netlify, Vercel).
# LinkedIn-Job-Trends-ELT-Pipeline
