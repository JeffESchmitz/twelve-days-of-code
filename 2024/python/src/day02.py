from pathlib import Path


def parse(input_str: str) -> list[list[int]]:
    """Parse input into list of reports (each report is a list of integers)."""
    reports = []
    for line in input_str.strip().splitlines():
        if not line.strip():
            continue
        levels = list(map(int, line.split()))
        reports.append(levels)
    return reports


def is_safe_report(levels: list[int]) -> bool:
    """Check if a report is safe (all increasing or all decreasing, with differences 1-3)."""
    if len(levels) < 2:
        return True

    # Calculate differences between consecutive levels
    differences = [levels[i+1] - levels[i] for i in range(len(levels) - 1)]

    # Check if all differences are within valid range (1-3 absolute value)
    if not all(1 <= abs(diff) <= 3 for diff in differences):
        return False

    # Check if all increasing or all decreasing
    all_increasing = all(diff > 0 for diff in differences)
    all_decreasing = all(diff < 0 for diff in differences)

    return all_increasing or all_decreasing


def is_safe_with_removal(levels: list[int]) -> bool:
    """Check if removing any single level makes the report safe."""
    # Try removing each level
    for i in range(len(levels)):
        reduced = levels[:i] + levels[i+1:]
        if is_safe_report(reduced):
            return True
    return False


def part1(input_str: str) -> int:
    """Count safe reports."""
    reports = parse(input_str)
    return sum(1 for report in reports if is_safe_report(report))


def part2(input_str: str) -> int:
    """Count reports that are safe or can be made safe by removing one level."""
    reports = parse(input_str)
    return sum(
        1 for report in reports
        if is_safe_report(report) or is_safe_with_removal(report)
    )


def load_input(path: Path | str | None = None) -> str:
    """Load puzzle input from file."""
    base = Path(__file__).resolve().parent.parent
    if path is None:
        path = base / "inputs" / "day02.txt"
    else:
        path = Path(path)
        if not path.is_absolute():
            path = base / path
    return path.read_text().strip()


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Day 02: Red-Nosed Reactor")
    parser.add_argument(
        "--input",
        type=Path,
        default=Path(__file__).resolve().parent.parent / "inputs" / "day02.txt",
        help="Path to input file (default: inputs/day02.txt)",
    )
    args = parser.parse_args()

    data = load_input(args.input)
    print(f"Part 1: {part1(data)}")
    print(f"Part 2: {part2(data)}")
