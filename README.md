# Advent of Code 2025

Swift solutions for all **12 days and 24 stars** of Advent of Code 2025, with notes on the algorithms and patterns learned along the way. This repository was formerly the multi-year Twelve Days of Code project; its earlier history remains in Git. The 2024 solutions are available in [AoC2024](https://github.com/JeffESchmitz/AoC2024).

## Getting started

From the repository root, use a Swift 6.2 or newer toolchain:

```sh
swift build --force-resolved-versions
swift test --force-resolved-versions --skip '_solution'  # public examples
swift run TwelveDaysOfCode 1                             # one day
./run.sh all                                            # all days, release build
```

The package builds the `TwelveDaysOfCode` executable and the `TDOCTests` test target. The public sample suite has 23 tests. Unfiltered `swift test` and `./test.sh` include solution tests that require personal puzzle inputs; they can fail or crash without those inputs. `./run.sh` with no arguments displays a message about all days but actually selects Day 1; pass `all` explicitly to run every day. Solutions also need personal inputs to produce meaningful results.

For input, put your session cookie in a private `.aoc-session` file, then run `./input.sh 1` to create `Sources/Day01+Input.swift`. The script defaults to 2025; set `AOC_YEAR` to override it. Session files and personal inputs are ignored by Git. `new_day.sh` is a historical generator that can overwrite existing files and defaults to the current year; it is not needed for setup.

Open `Package.swift` in Xcode with `xed .` or use the root VS Code launch configurations. See [QUICKSTART.md](QUICKSTART.md) and [CHECKLIST.md](CHECKLIST.md) for commands and setup checks.

## Progress and learning

| Day | Puzzle | Notes |
| --- | --- | --- |
| [1](Sources/Day01.swift) | Secret Entrance | [Learnings](Sources/Day01-learnings.md) |
| [2](Sources/Day02.swift) | Gift Shop | [Learnings](Sources/Day02-learnings.md) |
| [3](Sources/Day03.swift) | Lobby | [Learnings](Sources/Day03-learnings.md) |
| [4](Sources/Day04.swift) | Printing Department | [Learnings](Sources/Day04-learnings.md) |
| [5](Sources/Day05.swift) | Cafeteria | [Learnings](Sources/Day05-learnings.md) |
| [6](Sources/Day06.swift) | Trash Compactor | [Learnings](Sources/Day06-learnings.md) |
| [7](Sources/Day07.swift) | Laboratories | [Learnings](Sources/Day07-learnings.md) |
| [8](Sources/Day08.swift) | Playground | [Learnings](Sources/Day08-learnings.md) |
| [9](Sources/Day09.swift) | Movie Theater | [Learnings](Sources/Day09-learnings.md) |
| [10](Sources/Day10.swift) | Factory | [Learnings](Sources/Day10-learnings.md) |
| [11](Sources/Day11.swift) | Reactor | [Learnings](Sources/Day11-learnings.md) |
| [12](Sources/Day12.swift) | Christmas Tree Farm | [Learning tracker](TwelveDaysOfCode-2025-Learnings.md) |

The [2025 learning tracker](TwelveDaysOfCode-2025-Learnings.md) collects patterns and the broader journey. Additional shared resources include the [AoCTools cheatsheet](AoCTools-Cheatsheet.md), [puzzle teacher](AOC-PUZZLE-TEACHER.md), [agent quick start](AOC-AGENT-QUICK-START.md), [agent prompts](AOC-AGENT-PROMPTS.md), [agent stack](AOC-AGENT-STACK.md), [agent system guide](AOC-AGENT-SYSTEM-README.md), and [system map](AGENT-SYSTEM-MAP.md).

## Credits and license

The project uses [AoCTools](https://github.com/gereons/AoCTools) by Gereon Steffens. The original template and license credit Gereon Steffens; see [LICENSE.md](LICENSE.md) for the license text.
