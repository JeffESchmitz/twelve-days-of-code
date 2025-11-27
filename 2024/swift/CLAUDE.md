# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains solutions for Advent of Code 2024, implemented in Swift. It is based on Gereon Steffens' AoC2024 template, branched before the Day01 commit to leverage the project structure and helper utilities.

## Architecture

### Day Structure Pattern

Each day's solution follows a consistent architecture:

- **Day Class**: Each day is implemented as a final class conforming to `AdventOfCodeDay` protocol (from AoCTools package)
  - Must implement: `let title: String`, `let input: String`, `init(input: String)`, `func part1() async -> Int`, `func part2() async -> Int`
  - Located in `Sources/DayXX/DayXX.swift`

- **Input Data**: Puzzle input stored in `Sources/DayXX/DayXX+Input.swift` as a static extension property
  - Format: `extension DayXX { static let input = #"""..."""# }`

- **Parser Pattern**: Most days use swift-parsing library to parse input
  - Define custom `Parser` types for structured input (e.g., `PairParser`, `ReportParser`)
  - Parsers typically defined in the same file as the day's solution

- **Tests**: Each day has test file in `Tests/DayXXTests.swift`
  - Tests include both example input tests and solution verification tests
  - Uses Swift Testing framework with `@Suite` and `@Test` attributes
  - Tests are marked `@MainActor` and async

### Main Entry Point

`Sources/AoC.swift` contains the main entry point:
- Register new days in the `days` array (line 68-74)
- Supports running: single day, all days sequentially, or all days in parallel
- Command-line arguments: `<day-number>`, `all`, or `all-parallel`
- Auto-detects current day in December

## Common Commands

### Building and Running

- **Run a specific day**: `./run <day-number>` or `swift run AdventOfCode <day-number>`
- **Run all days sequentially**: `./run all`
- **Run all days in parallel**: `./run all-parallel`
- **Build**: `swift build`
- **Build release**: `swift build --configuration release`

### Testing

- **Run all tests**: `./test` or `swift test`
- **Run tests for specific day**: `./test <day-number>` (e.g., `./test 1` runs Day01 tests)
- **Test filter used**: `--filter AoCTests.Day<XX>` where XX is zero-padded day number

### Getting Puzzle Input

- **Download input for a day**: `./input.sh <day-number>`
  - Requires `.aoc-session` file with Advent of Code session cookie
  - Automatically creates `Sources/DayXX/DayXX+Input.swift` with downloaded input
  - Defaults to current day if no argument provided

## Dependencies

- **AoCTools** (0.1.6+): Provides `AdventOfCodeDay` protocol, `Timer`, and utility types
- **swift-parsing** (0.13.0+): Point-Free's parsing library for input parsing
- **SwiftLintPlugin** (0.55.1+): Code linting (configured in `.swiftlint.yml`)

## Development Workflow

1. **Create new day structure**:
   - Create directory `Sources/DayXX/` where XX is zero-padded day number
   - Create `Sources/DayXX/DayXX.swift` with day class implementing `AdventOfCodeDay`
   - Run `./input.sh <day>` to download puzzle input

2. **Register the day**: Add to `days` array in `Sources/AoC.swift` (line 68-74)

3. **Create tests**: Create `Tests/DayXXTests.swift` with test suite following existing pattern

4. **Implement solution**:
   - Parse input (typically using swift-parsing combinators)
   - Implement `part1()` and `part2()` methods
   - Run with `./run <day>` to verify

## Code Style

- SwiftLint is configured with specific rules (see `.swiftlint.yml`)
- Input files (`*+Input.swift`) are excluded from linting
- Disabled rules include: file_length, identifier_name, line_length, cyclomatic_complexity
- Functional Swift patterns preferred (map, reduce, filter, zip, etc.)
