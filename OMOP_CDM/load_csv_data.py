import os
import sqlite3

import pandas as pd


def normalize_columns(frame: pd.DataFrame) -> pd.DataFrame:
    frame.columns = frame.columns.str.strip()
    if frame.columns.duplicated().any():
        frame = frame.loc[:, ~frame.columns.duplicated()]
    lower_cols = frame.columns.str.lower()
    if lower_cols.duplicated().any():
        frame = frame.loc[:, ~lower_cols.duplicated()]
    return frame


def ensure_column(
    frame: pd.DataFrame,
    column_name: str,
    value: str,
) -> pd.DataFrame:
    lower_cols = frame.columns.str.lower()
    if column_name in lower_cols.values:
        existing = frame.columns[lower_cols == column_name][0]
        frame[existing] = value
    else:
        frame.insert(len(frame.columns), column_name, value)
    return frame


def load_csv_to_sqlite(
    csv_path: str,
    table_name: str,
    state: str,
    conn: sqlite3.Connection,
    chunksize: int = 100_000,
) -> None:
    reader = pd.read_csv(csv_path, chunksize=chunksize)
    for chunk in reader:
        chunk = normalize_columns(chunk)
        chunk = ensure_column(chunk, "state", state)
        chunk = ensure_column(chunk, "tenant_id", state)
        chunk.to_sql(table_name, conn, if_exists="append", index=False)


conn = sqlite3.connect("ehr.db")

base_dir = "../"
skip_dirs = {"OMOP_CDM", ".git", ".venv"}

for state in os.listdir(base_dir):
    if state in skip_dirs or state.startswith("."):
        continue
    state_path = os.path.join(base_dir, state)
    if not os.path.isdir(state_path):
        continue

    for filename in os.listdir(state_path):
        if not filename.endswith(".csv"):
            continue
        csv_path = os.path.join(state_path, filename)
        table_stem = os.path.splitext(filename)[0].lower()
        table_name = f"raw_{table_stem}"
        load_csv_to_sqlite(csv_path, table_name, state, conn)

conn.close()
