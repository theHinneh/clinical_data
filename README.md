# OMOP Clinical Data

Synthetic medical records for all 50 US states, generated with [Synthea](https://synthetichealth.github.io/synthea/).
The data is modeled and consolidated using [dbt](https://www.getdbt.com/) and [DuckDB](https://duckdb.org/).

_If you're wondering how I got gigabytes of CSV files to GitHub, I used git-lfs._

The goal is to make the CSV files useful -- starting with analytics engineering, 
and potentially moving toward conversational analytics (chatting with the data). 
I'll be technical, but also explain some of my decisions along the way.

## Architecture

```
clinical_data/
├── Alabama/                  # One folder per state, each containing 18 CSV files
│   ├── patients.csv
│   ├── encounters.csv
│   └── ...
├── Alaska/
│   └── ...
├── ... (all 50 states)
│
└── ANALYTICS_ENGINEERING/
    └── dbt_omop/             # dbt project that unions all states into DuckDB
        ├── models/
        │   ├── staging/
        │   ├── intermediate/
        │   └── mart/
        ├── macros/
        │   └── ...
        └── omop.duckdb       <-- output database
```

## Data

Each state directory contains 18 CSV files representing core clinical entities:

| File | Description |
|---|---|
| `patients.csv` | Demographics, addresses, income, healthcare expenses |
| `encounters.csv` | Patient-provider visits |
| `conditions.csv` | Diagnoses |
| `medications.csv` | Prescriptions |
| `procedures.csv` | Medical procedures |
| `observations.csv` | Clinical measurements |
| `allergies.csv` | Patient allergies |
| `careplans.csv` | Treatment plans |
| `claims.csv` | Insurance claims |
| `claims_transactions.csv` | Claim line-item transactions |
| `immunizations.csv` | Vaccinations |
| `devices.csv` | Medical devices |
| `imaging_studies.csv` | Radiology and imaging |
| `supplies.csv` | Medical supplies |
| `organizations.csv` | Healthcare facilities |
| `providers.csv` | Healthcare providers |
| `payers.csv` | Insurance companies |
| `payer_transitions.csv` | Insurance coverage changes |

All data is **synthetic** -- no real patient information.

## Analytics Engineering

The [`ANALYTICS_ENGINEERING/dbt_omop/`](ANALYTICS_ENGINEERING/dbt_omop/) project reads the CSVs from all 50 states, 
tags each row with its source state, and unions them into staging views inside a DuckDB database.

> [!WARNING]
> You need the [OMOP vocabulary files from Athena](https://athena.ohdsi.org/) for this to work fully.
> Download them and place the CSVs in `ANALYTICS_ENGINEERING/dbt_omop/seeds/`.
>
> My first instinct was to load them with `dbt seed`, but the Athena files are tab-delimited
> and some have fields that exceed Python's csv parser limits -- so `dbt seed` chokes on them.
> Instead, the vocabulary models load the CSVs directly through DuckDB's `read_csv_auto()`,
> bypassing Python entirely. Same result, no drama.

## Quick Start

```bash
cd ANALYTICS_ENGINEERING/dbt_omop

python -m venv .venv && source .venv/bin/activate
pip install -r ../requirements.txt

# Set ROOT_DIR to the absolute path of this clinical_data/ directory
cp .env.example .env && source .env

dbt run
```

## Roadmap

- Staging, intermediate, and marts layers in dbt
- Conversational analytics -- chat with the data
