# 2024 – Python

Minimal Python port of Advent of Code 2024 solutions. Currently includes Day 1 (“Historian Hysteria”).

## Setup
```bash
cd 2024/python
python -m venv .venv
source .venv/bin/activate        # or .venv\\Scripts\\activate on Windows
pip install -r requirements.txt
```

## Running
```bash
python src/day01.py                 # uses inputs/day01.txt
python src/day01.py --input path/to/input.txt

# Multi-day runner (registry-based; currently Day 1)
python -m run --day 1
```

## Testing
```bash
pytest
pytest -k day01
```

## Layout
```
2024/python/
├── inputs/day01.txt      # puzzle input (copied from Swift track)
├── src/day01.py          # implementation
├── src/run.py            # simple multi-day runner (extend registry as you port more)
└── tests/test_day01.py   # pytest coverage (sample + full input)
```
