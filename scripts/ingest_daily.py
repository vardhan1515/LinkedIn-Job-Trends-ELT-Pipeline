import argparse
import os
from datetime import datetime, timezone
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text


def build_engine():
    host = os.getenv('DB_HOST', 'localhost')
    port = os.getenv('DB_PORT', '5432')
    user = os.getenv('DB_USER', 'postgres')
    password = os.getenv('DB_PASSWORD', 'postgres')
    database = os.getenv('DB_NAME', 'job_warehouse')
    url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    return create_engine(url)


def ensure_schema_and_table(engine, table_name: str, schema: str) -> None:
    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema}"))
        # Create table with all columns as text to preserve raw values
        conn.execute(text(f"""
            CREATE TABLE IF NOT EXISTS {schema}.{table_name} (
                job_id TEXT,
                company_name TEXT,
                title TEXT,
                description TEXT,
                max_salary TEXT,
                pay_period TEXT,
                location TEXT,
                company_id TEXT,
                views TEXT,
                med_salary TEXT,
                min_salary TEXT,
                formatted_work_type TEXT,
                applies TEXT,
                original_listed_time TEXT,
                remote_allowed TEXT,
                job_posting_url TEXT,
                application_url TEXT,
                application_type TEXT,
                expiry TEXT,
                closed_time TEXT,
                formatted_experience_level TEXT,
                skills_desc TEXT,
                listed_time TEXT,
                posting_domain TEXT,
                sponsored TEXT,
                work_type TEXT,
                currency TEXT,
                compensation_type TEXT,
                normalized_salary TEXT,
                zip_code TEXT,
                fips TEXT,
                load_date DATE,
                ingested_at TIMESTAMP
            )
        """))


def main() -> int:
    parser = argparse.ArgumentParser(description='Load one daily CSV into raw_job_postings.')
    parser.add_argument('--csv', required=True)
    parser.add_argument('--load-date', required=True, help='YYYY-MM-DD batch date')
    args = parser.parse_args()

    csv_path = Path(args.csv)
    if not csv_path.exists():
        raise SystemExit(f"CSV not found: {csv_path}")

    load_date = datetime.strptime(args.load_date, '%Y-%m-%d').date()
    ingested_at = datetime.now(timezone.utc)

    df = pd.read_csv(csv_path)
    df['load_date'] = load_date
    df['ingested_at'] = ingested_at

    engine = build_engine()
    ensure_schema_and_table(engine, 'raw_job_postings', 'raw')

    # Append-only load
    df.to_sql(
        'raw_job_postings',
        engine,
        schema='raw',
        if_exists='append',
        index=False,
        method='multi',
        chunksize=2000,
    )

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
