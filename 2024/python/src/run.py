from __future__ import annotations

import argparse
from pathlib import Path
from typing import Callable, Dict, Tuple

import day01


# Registry of available days. Extend this as more ports are added.
PARTS: Dict[int, Tuple[Callable[[str], int], Callable[[str], int]]] = {
    1: (day01.part1, day01.part2),
}


def load_input(day: int, path: Path | None = None) -> str:
    base = Path(__file__).resolve().parent.parent
    if path is None:
        path = base / "inputs" / f"day{day:02d}.txt"
    else:
        if not path.is_absolute():
            path = base / path
    return path.read_text().strip()


def main() -> None:
    parser = argparse.ArgumentParser(description="Run Advent of Code 2024 solutions (Python).")
    parser.add_argument(
        "-d",
        "--day",
        type=int,
        required=True,
        help="Day number to run (e.g., 1)",
    )
    parser.add_argument(
        "--input",
        type=Path,
        default=None,
        help="Override input file path (defaults to inputs/dayXX.txt)",
    )
    args = parser.parse_args()

    if args.day not in PARTS:
        raise SystemExit(f"No Python solution registered for day {args.day}")

    part1_fn, part2_fn = PARTS[args.day]
    data = load_input(args.day, args.input)

    p1 = part1_fn(data)
    p2 = part2_fn(data)

    print(f"Day {args.day:02d}")
    print(f"  Part 1: {p1}")
    print(f"  Part 2: {p2}")


if __name__ == "__main__":
    main()
