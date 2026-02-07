import argparse
from pathlib import Path
import pandas as pd


def main() -> int:
    parser = argparse.ArgumentParser(description='Split raw postings into daily CSVs by listed_time.')
    parser.add_argument('--input', default='data/source/postings.csv')
    parser.add_argument('--output-dir', default='data/daily')
    parser.add_argument('--date-column', default='listed_time')
    args = parser.parse_args()

    input_path = Path(args.input)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Stream in chunks to handle large files
    reader = pd.read_csv(input_path, chunksize=200_000)

    for chunk in reader:
        if args.date_column not in chunk.columns:
            raise SystemExit(f"Missing column: {args.date_column}")

        posted_date = pd.to_datetime(chunk[args.date_column], unit='ms', errors='coerce').dt.date
        if posted_date.isna().all():
            raise SystemExit('All dates are NaT. Check date column and format.')

        chunk = chunk.copy()
        chunk['posted_date'] = posted_date

        for date_value, group in chunk.groupby('posted_date'):
            if pd.isna(date_value):
                continue
            out_path = output_dir / f"{date_value}.csv"
            write_header = (not out_path.exists()) or (out_path.exists() and out_path.stat().st_size == 0)
            group.drop(columns=['posted_date']).to_csv(out_path, index=False, mode='a', header=write_header)

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
