# TDOC 2025 - Quick Reference

## 📋 Summary of Changes Made

### 1. **Swift Version Compatibility** ✅
- Changed `Package.swift` from Swift 6.2 → **Swift 6.0**
- This ensures compatibility between macOS and Ubuntu
- Created `.swiftly.env` to lock Swift version to 6.0.3

### 2. **Updated Day Ranges** ✅
- Changed from 25 days (AoC) → **12 days (TDOC)**
- Updated `TDOC.swift` to accept days 1-12
- Updated `README.md` references

### 3. **New Files Created** ✅
- `SETUP.md` - Complete setup guide for both platforms
- `new_day.sh` - Script to generate day templates
- `.swiftly.env` - Swift version lock file

---

## 🚀 Quick Start

### First Time Setup

**On macOS:**
```bash
swiftly use 6.0.3
swift build
swift test
```

**On Ubuntu:**
```bash
# Install swiftly if needed
curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash

# Install Swift 6.0
swiftly install 6.0.3
swiftly use 6.0.3

# Build and test
swift build
swift test
```

### Daily Workflow

```bash
# 1. Create new day files (e.g., Day 5)
chmod +x new_day.sh
./new_day.sh 5

# 2. Add puzzle input to Sources/Day05+Input.swift

# 3. Write solution in Sources/Day05.swift

# 4. Run your solution
swift run TwelveDaysOfCode 5

# 5. Run tests
swift test --filter Day05Tests
```

---

## 🏗️ Project Structure

```
TwelveDaysOfCode/
├── Package.swift              # Swift package definition
├── README.md                  # Main documentation
├── SETUP.md                   # Platform setup guide
├── .swiftly.env              # Swift version lock
├── new_day.sh                # Template generator script
│
├── Sources/
│   ├── TDOC.swift            # Main entry point
│   ├── AdventOfCodeDay.swift # Protocol definition
│   ├── Day01.swift           # Day 1 solution
│   ├── Day01+Input.swift     # Day 1 input (gitignored)
│   ├── Day02.swift           # Day 2 solution
│   └── ...                   # Days 3-12
│
└── Tests/
    ├── Tag.swift             # Test tag definitions
    ├── Day01Tests.swift      # Day 1 tests
    ├── Day02Tests.swift      # Day 2 tests
    └── ...                   # Days 3-12 tests
```

---

## 💻 Common Commands

### Running Puzzles

```bash
# Run today's puzzle (Dec 1-12)
swift run

# Run specific day
swift run TwelveDaysOfCode 1

# Run all days sequentially
swift run TwelveDaysOfCode all

# Run all days in parallel (faster)
swift run TwelveDaysOfCode all-parallel

# Run with optimizations (recommended for slow solutions)
swift run -c release TwelveDaysOfCode 5
```

### Running Tests

```bash
# Run all tests
swift test

# Run tests for specific day
swift test --filter Day01Tests

# Run only test input tests (not full solutions)
swift test --filter "testInput"

# Run in parallel (faster)
swift test --parallel
```

### Development

```bash
# Build without running
swift build

# Clean build artifacts
swift package clean

# Update dependencies
swift package update

# Generate Xcode project (macOS only)
xed .
```

---

## 🎯 Solution Template

Each day follows this pattern:

```swift
// Sources/DayXX.swift
import AoCTools

final class DayXX: AdventOfCodeDay {
    let title = "Puzzle Title Here"
    
    // Your parsed data
    let data: [String]
    
    init(input: String) {
        // Parse the input
        self.data = input.lines
    }
    
    func part1() async -> Int {
        // Solve part 1
        return 0
    }
    
    func part2() async -> Int {
        // Solve part 2
        return 0
    }
}
```

```swift
// Sources/DayXX+Input.swift
extension DayXX {
    static let input = """
    paste your puzzle input here
    """
}
```

---

## 🧪 Testing Pattern

```swift
// Tests/DayXXTests.swift
import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
paste example input from puzzle
"""

@Suite("Day XX Tests")
struct DayXXTests {
    @Test("Day XX Part 1", .tags(.testInput))
    func testDayXX_part1() async {
        let day = DayXX(input: testInput)
        await #expect(day.part1() == expectedAnswer)
    }
    
    @Test("Day XX Part 1 Solution")
    func testDayXX_part1_solution() async {
        let day = DayXX(input: DayXX.input)
        await #expect(day.part1() == yourActualAnswer)
    }
}
```

---

## 🛠️ AoCTools Utilities

Your project includes [AoCTools](https://codeberg.org/gereon/AoCTools) with helpful utilities:

### Parsing
- `input.lines` - Split by newlines
- `input.words` - Split by whitespace
- `input.integers()` - Extract all integers
- `"1,2,3".integers(",")` - Parse with custom separator

### Grid/Points
- `Point` - 2D coordinate with neighbors, manhattan distance
- `Point3` - 3D coordinate
- `Grid<T>` - 2D grid with helpful methods
- `HexGrid` - Hexagonal grid support

### Pathfinding
- `aStar()` - A* pathfinding algorithm
- `bfs()` - Breadth-first search

### Other
- `combinations()` - Generate combinations
- `permutations()` - Generate permutations
- Various collection extensions

---

## 🔧 Troubleshooting

### "Package.swift manifest parsing error"
- Check your Swift version: `swift --version`
- Should be 6.0 or later
- Switch version: `swiftly use 6.0.3`

### "Cannot find 'Day01' in scope"
- Make sure all DayXX.swift files are in the Sources/ directory
- Run `swift build` to rebuild

### Tests not running
- Verify test files are in Tests/ directory
- Check that test files are named correctly: `DayXXTests.swift`

### Different results on macOS vs Ubuntu
- This shouldn't happen with pure Swift code
- Check that both systems are using the same Swift version
- Verify input files are identical (watch for line ending differences)

---

## 📝 Tips for Success

1. **Start with the test input** - Get it working with the example before trying your full input
2. **Use print() liberally** - Debug by printing intermediate results
3. **Leverage AoCTools** - Check if there's already a utility for what you need
4. **Write tests first** - Use TDD when possible
5. **Optimize later** - Get it working first, then optimize if needed
6. **Use release mode for slow solutions** - `swift run -c release`

---

## 📅 Schedule

- **December 1-12, 2025**: One puzzle released each day
- Running `swift run` during this period automatically runs today's puzzle
- Outside this period, `swift run` runs all puzzles

---

## 🎉 Have Fun!

Remember: The goal is to learn and have fun. Don't stress about:
- Optimal solutions (unless yours is too slow)
- Beautiful code (refactor later if you want)
- Comparing to others (everyone has different backgrounds)

Good luck with TDOC 2025! 🎄✨
