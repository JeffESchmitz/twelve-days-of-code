# Twelve Days of Code 2025

My TDOC 2025 Solutions in Swift

### Overview

All code for all days is compiled into a single macOS commandline binary, which can be run either from within Xcode or from Terminal.

Each day usually has 3 associated source files:

* `DayX.swift` for the solution code
* `DayX+Input.swift` for the puzzle input. This file is created by running the `input.sh` script (see below) but is not included in this repo for [legal reasons](https://www.reddit.com/r/adventofcode/wiki/faqs/copyright/inputs).
* `DayXTests.swift` for the test suite, if the puzzle has test cases

`TDOC.swift` has the `main()` function which runs one (or all) of the puzzles, then prints the solution(s) and the elapsed time.

The code relies on my own [AoCTools](https://codeberg.org/gereon/AoCTools) package where I started collecting utility functions for things frequently used in AoC, such as 2D and 3D points, [hexagonal grids](https://www.redblobgames.com/grids/hexagons/), an [A\* pathfinder](https://en.wikipedia.org/wiki/A*_search_algorithm) and more.

### Xcode

Open the project via the `Package.swift` file (`xed .` from Terminal in the project directory). `Cmd-R` will either run the puzzle for the current calendar day during December, or for all days in other months. To override this, change `defaultDay` in `TDOC.swift`.

`Cmd-U` runs the test suite for all 12 days. Run individual tests by clicking on them in the Test Inspector (`Cmd-6`)

### Commandline

From the commandline, use `swift run` or `swift run -c release`. 

To run the puzzle for a specific day without changing `TDOC.swift`, use `swift run TwelveDaysOfCode X` to run day `X`. `X` can be a number from 1 to 12 or `all`.

To run tests, use `swift test` for all tests, or e.g. `swift test --filter TDOCTests.Day02Tests` to run the tests for day 2.

### Puzzle Inputs

Use the included `input.sh` script to download your puzzle input. To be able to run this script, [grab the session cookie](https://www.reddit.com/r/adventofcode/comments/a2vonl/how_to_download_inputs_with_a_script/) from [adventofcode.com](https://adventofcode.com) and create a `.aoc-session` file with the contents. `input.sh` downloads the input for the current day by default, use `input.sh X` to download day X's input.

## 2025 Progress

| Day | Title | Stars | Key Technique |
|-----|-------|:-----:|---------------|
| [1](Sources/Day01.swift) | Secret Entrance | ⭐⭐ | Simulation + Modular Arithmetic |
| [2](Sources/Day02.swift) | Gift Shop | ⭐⭐ | Arithmetic Pattern Detection |
| [3](Sources/Day03.swift) | Lobby | ⭐⭐ | Suffix Maximum + Monotonic Stack |
| [4](Sources/Day04.swift) | Printing Department | ⭐⭐ | Neighbor-Counting Grid + Simulation |
| [5](Sources/Day05.swift) | Cafeteria | ⭐⭐ | PointFree Parsing + Interval Merging |
| [6](Sources/Day06.swift) | Trash Compactor | ⭐⭐ | Column-Based Grid Parsing |
| [7](Sources/Day07.swift) | Laboratories | ⭐⭐ | Set vs Dict (merge vs accumulate) + Pre-parsed O(1) lookups |
| 8 | | | |
| 9 | | | |
| 10 | | | |
| 11 | | | |
| 12 | | | |

**Total: 14/24 stars** ⭐

<!--- advent_readme_stars table --->
