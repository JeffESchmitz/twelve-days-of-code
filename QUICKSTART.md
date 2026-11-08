# Advent of Code 2025 quick reference

Run these commands from the repository root with Swift 6.2 or newer:

```sh
swift --version
swift build --force-resolved-versions
swift test --force-resolved-versions --skip '_solution'
swift test --filter TDOCTests.Day01Tests --skip '_solution'
swift run TwelveDaysOfCode 1
./run.sh all
```

The public sample suite contains 23 tests for the 12 completed days. Unfiltered `swift test` and `./test.sh` also run solution tests that require personal inputs and may fail or crash without them. `./run.sh` without arguments selects Day 1 despite its message; pass `all` to run all days.

To obtain an input, save your session cookie privately in `.aoc-session`, then use `./input.sh 1`. It defaults to 2025 and writes `Sources/Day01+Input.swift`; `AOC_YEAR` overrides the year. These private files are ignored by Git. The historical `new_day.sh` generator can overwrite existing files and defaults to the current year, so it is not a setup step.

The root package contains `Sources/` (solutions and notes), `Tests/`, `Package.swift`, and the tracked `Package.resolved`. `Sources/TDOC.swift` runs the `TwelveDaysOfCode` executable. Open the package with `xed .` for Xcode. For deeper notes, see the [learning tracker](TwelveDaysOfCode-2025-Learnings.md) and [AoCTools cheatsheet](AoCTools-Cheatsheet.md).
