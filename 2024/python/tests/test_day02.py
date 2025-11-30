from pathlib import Path
import sys
import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.append(str(ROOT / "src"))

import day02  # noqa: E402


SAMPLE = """\
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""


def test_part1_sample():
    assert day02.part1(SAMPLE) == 2


def test_part2_sample():
    assert day02.part2(SAMPLE) == 4


def test_is_safe_report_single_level():
    assert day02.is_safe_report([1]) == True


def test_is_safe_report_repeated_values():
    assert day02.is_safe_report([1, 1, 1]) == False


def test_is_safe_report_mixed_trends():
    assert day02.is_safe_report([1, 2, 3, 2, 3]) == False


def test_is_safe_report_boundary_differences():
    assert day02.is_safe_report([1, 2, 3, 6, 9]) == True


def test_is_safe_report_empty():
    assert day02.is_safe_report([]) == True


INPUT_PATH = ROOT / "inputs" / "day02.txt"


@pytest.mark.skipif(not INPUT_PATH.exists(), reason="Personal AoC input not provided")
def test_part1_solution():
    data = day02.load_input(INPUT_PATH)
    assert day02.part1(data) == 663


@pytest.mark.skipif(not INPUT_PATH.exists(), reason="Personal AoC input not provided")
def test_part2_solution():
    data = day02.load_input(INPUT_PATH)
    assert day02.part2(data) == 692
