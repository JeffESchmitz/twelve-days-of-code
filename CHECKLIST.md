# Advent of Code 2025 setup checklist

- [ ] Install or select Swift 6.2 or newer and check `swift --version`.
- [ ] From the repository root, run `swift build --force-resolved-versions`.
- [ ] Run the 23 public examples with `swift test --force-resolved-versions --skip '_solution'`.
- [ ] To run solutions, privately store your session cookie in `.aoc-session` and obtain the desired input with `./input.sh 1`. The file is written to `Sources/Day01+Input.swift` and is ignored by Git; `AOC_YEAR` overrides the default 2025 year.
- [ ] Run one day with `swift run TwelveDaysOfCode 1`, or all days with `./run.sh all`. The wrapper's no-argument message is misleading: it selects Day 1.

All 12 days are complete. Unfiltered `swift test` and `./test.sh` include personal-input solution tests, which may fail or crash without the inputs. The historical `new_day.sh` generator can overwrite existing files and defaults to the current year; it is not required for setup. See [QUICKSTART.md](QUICKSTART.md) and [README.md](README.md).
