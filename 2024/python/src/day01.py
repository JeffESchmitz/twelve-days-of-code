from collections import Counter
from pathlib import Path


def parse(input_str: str) -> tuple[list[int], list[int]]:
    """Parse two-column input into left/right integer lists."""
    left: list[int] = []
    right: list[int] = []
    for line in input_str.strip().splitlines():
        if not line.strip():
            continue
        parts = line.split()
        if len(parts) != 2:
            raise ValueError(f"Invalid line: {line!r}")
        a, b = map(int, parts)
        left.append(a)
        right.append(b)
    return left, right


def part1(input_str: str) -> int:
    left, right = parse(input_str)
    left_sorted = sorted(left)
    right_sorted = sorted(right)
    return sum(abs(a - b) for a, b in zip(left_sorted, right_sorted))


def part2(input_str: str) -> int:
    left, right = parse(input_str)
    counts = Counter(right)
    return sum(value * counts[value] for value in left)


def load_input(path: Path | str | None = None) -> str:
    base = Path(__file__).resolve().parent.parent
    if path is None:
        path = base / "inputs" / "day01.txt"
    else:
        path = Path(path)
        if not path.is_absolute():
            path = base / path
    return path.read_text().strip()


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Day 01: Historian Hysteria")
    parser.add_argument(
        "--input",
        type=Path,
        default=Path(__file__).resolve().parent.parent / "inputs" / "day01.txt",
        help="Path to input file (default: inputs/day01.txt)",
    )
    args = parser.parse_args()

    data = load_input(args.input)
    print(f"Part 1: {part1(data)}")
    print(f"Part 2: {part2(data)}")
