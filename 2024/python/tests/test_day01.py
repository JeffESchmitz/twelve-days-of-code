from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.append(str(ROOT / "src"))

import day01  # noqa: E402


SAMPLE = """\
3   4
4   3
2   5
1   3
3   9
3   3
"""


def test_part1_sample():
    assert day01.part1(SAMPLE) == 11


def test_part2_sample():
    assert day01.part2(SAMPLE) == 31


def test_part1_solution():
    data = day01.load_input(ROOT / "inputs" / "day01.txt")
    assert day01.part1(data) == 2769675


def test_part2_solution():
    data = day01.load_input(ROOT / "inputs" / "day01.txt")
    assert day01.part2(data) == 24643097
