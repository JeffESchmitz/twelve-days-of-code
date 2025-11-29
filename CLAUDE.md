# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Multi-year, multi-language solutions for Twelve Days of Code (formerly Advent of Code). Organized by `YYYY/<language>/` with Swift as the primary language and Python as secondary.

**Structure:**
- `2024/swift/` - Complete 2024 solutions (23/25 days, 46/50 stars)
- `2024/python/` - Python port (Day 1 complete, pytest-based)
- `2025/swift/` - Prepared starter kit with 12 day stubs

## Commands by Language

### Swift 2024 (`2024/swift/`)
```bash
swift build                    # Build project
swift test                     # Run all tests
./run <day>                    # Run specific day (e.g., ./run 22)
./run all                      # Run all days sequentially
./test <day>                   # Test specific day
./input.sh <day>               # Download puzzle input (requires .aoc-session)
swift build --configuration release
```

### Swift 2025 (`2025/swift/`)
```bash
swift run TwelveDaysOfCode <day>   # Run day (1-12 or 'all')
swift run TwelveDaysOfCode         # Auto-runs current day in December
swift test                         # Run all tests
swift test --filter TDOCTests.Day02Tests  # Filter by day
```

### Python (`2024/python/`)
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python src/day01.py                # Run directly
python src/day01.py --input path/to/input.txt
python -m run --day 1              # Registry runner
pytest                             # Run all tests
pytest -k day01                    # Filter tests
```

## Architecture

### Swift Day Pattern
Each day has 3 files:
- `DayXX.swift` - Solution implementing `AdventOfCodeDay` protocol (from AoCTools)
- `DayXX+Input.swift` - Puzzle input as static extension (created by `input.sh`)
- `DayXXTests.swift` - Tests using Swift Testing framework (`@Suite`, `@Test`, `@MainActor`, async)

Entry points:
- 2024: `Sources/AoC.swift` - Manual day registration in `days` array
- 2025: `Sources/TDOC.swift` - Auto-runs current day in December

### Python Day Pattern
- `src/dayXX.py` - Functions: `parse()`, `part1()`, `part2()`, `load_input()`
- `src/run.py` - Registry runner (extend `PARTS` dict for new days)
- `tests/test_dayXX.py` - pytest with `@pytest.mark.skipif` for input gating

### Input Files
Not committed per AoC copyright rules. Download via:
- Swift: `./input.sh <day>` (requires `.aoc-session` with session cookie)
- Python: Copy from Swift track or download manually to `inputs/dayXX.txt`

## Dependencies

### Swift
- `AoCTools` (0.1.6+): AdventOfCodeDay protocol, Timer, 2D/3D points, pathfinding
- `swift-parsing` (0.13.0+): Parser combinators for input parsing
- `swift-collections` (1.3.0+): Deque, OrderedSet, OrderedDict
- `SwiftLintPlugin` (0.55.1+): Code linting

### Python
- `pytest` (7.0+): Testing framework only

## Code Style

Swift linting configured in `.swiftlint.yml`:
- Input files (`*+Input.swift`) excluded from linting
- Disabled: file_length, identifier_name, line_length, cyclomatic_complexity
- Parser combinators from swift-parsing preferred for complex input

## Key Patterns

Algorithm selection by problem type:
- Shortest path: BFS
- "First X that...": Binary search
- "Count all ways": Dynamic programming/memoization
- Grid traversal: BFS/DFS/flood fill

Performance-critical choices:
- `Set.contains()` O(1) vs `Array.contains()` O(n)
- `Deque.popFirst()` O(1) vs `Array.removeFirst()` O(n)
- Dictionary keys for memoization

Three-phase architecture: Precompute expensive work, optimize selection, scale with caching.
