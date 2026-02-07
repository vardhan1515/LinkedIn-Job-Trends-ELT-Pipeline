import os
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


def export_query(engine, sql: str, out_path: Path) -> None:
    df = pd.read_sql(sql, engine)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    df.to_json(out_path, orient='records')


def main() -> int:
    engine = build_engine()
    out_dir = Path('public/data')

    export_query(
        engine,
        """
        select month_start, skill, category, posting_count
        from analytics_marts.mart_skill_demand_monthly
        order by month_start, posting_count desc
        """,
        out_dir / 'skill_demand_monthly.json'
    )

    export_query(
        engine,
        """
        select month_start, role, posting_count
        from analytics_marts.mart_role_trends_monthly
        order by month_start, posting_count desc
        """,
        out_dir / 'role_trends_monthly.json'
    )

    export_query(
        engine,
        """
        select month_start, role, remote_share
        from analytics_marts.mart_remote_share_monthly
        order by month_start, role
        """,
        out_dir / 'remote_share_monthly.json'
    )

    export_query(
        engine,
        """
        select month_start, company_name, posting_count
        from analytics_marts.mart_top_companies_monthly
        order by month_start, posting_count desc
        """,
        out_dir / 'top_companies_monthly.json'
    )

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
