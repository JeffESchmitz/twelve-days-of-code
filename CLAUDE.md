# Advent of Code 2025 project guidance

This root Swift package contains all 12 completed days. The executable target is `TwelveDaysOfCode`, the test target is `TDOCTests`, and `Sources/TDOC.swift` is the runner. Preserve existing solutions and learning notes when working on unrelated tasks.

Use Swift 6.2 or later and work from the repository root:

```sh
swift build --force-resolved-versions
swift test --force-resolved-versions --skip '_solution'  # 23 public sample tests
swift test --filter TDOCTests.Day01Tests --skip '_solution'
swift run TwelveDaysOfCode 1
./run.sh all
```

Unfiltered `swift test` and `./test.sh` include private-input solution tests and may fail or crash without personal inputs. The no-argument `run.sh` wrapper says it runs all days but selects Day 1; pass `all` explicitly. `input.sh` downloads a personal input into `Sources/DayXX+Input.swift` using `.aoc-session` and defaults to 2025; neither credentials nor inputs belong in Git. `new_day.sh` is a historical generator and can overwrite existing files; do not run it as setup.

See [README.md](README.md), [QUICKSTART.md](QUICKSTART.md), and the [learning tracker](TwelveDaysOfCode-2025-Learnings.md).
