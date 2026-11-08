# Day 06: Trash Compactor - Learning Notes

**Puzzle**: https://adventofcode.com/2025/day/6

**Completed**: December 11, 2025

## Problem Summary

- **Part 1**: Parse a horizontal math worksheet where numbers are read horizontally, apply +/* operations, sum all results
- **Part 2**: Same worksheet, but numbers are read vertically (cephalopod math!) - each column of digits forms one number

**Input**: 5 rows - 4 number rows + 1 operator row. Problems separated by full columns of spaces.

## Solutions

- **Part 1**: 4,309,240,495,780
- **Part 2**: 9,170,286,552,289

## Core Concepts Learned

### 1. 2D Grid Parsing - Column-Based Analysis

This puzzle required thinking about the input as a **grid of characters** rather than lines of text.

**Key Insight**: Problems are separated by columns where ALL rows have spaces.

```swift
/// Find all column indices where every row has a space character
private func findSeparatorColumns() -> [Int] {
    let allRows = numberRows + [operatorRow]

    return (0..<width).filter { col in
        allRows.allSatisfy { row in
            let index = row.index(row.startIndex, offsetBy: col)
            return row[index] == " "
        }
    }
}
```

### 2. Grouping Consecutive Elements

Separator columns often appear consecutively (e.g., `[3, 4, 8, 9, 14]`). We need to group them to find the actual boundaries between problems.

```swift
// Group consecutive separator columns
var groups: [[Int]] = []
var currentGroup = [separators[0]]

for i in 1..<separators.count {
    if separators[i] == separators[i - 1] + 1 {
        // Consecutive - add to current group
        currentGroup.append(separators[i])
    } else {
        // Gap found - start new group
        groups.append(currentGroup)
        currentGroup = [separators[i]]
    }
}
groups.append(currentGroup)
```

**Visual Example**:
```
Separators: [3, 4, 8, 9, 14]
Groups:     [[3, 4], [8, 9], [14]]
Ranges:     [0..<3, 5..<8, 10..<14, 15..<width]
```

### 3. Range<Int> for Problem Boundaries

Using `Range<Int>` instead of tuples gives us:
- Type safety
- Built-in iteration (`for col in range`)
- Works with String subscripts from AoCTools

```swift
private func findProblemRanges(separators: [Int]) -> [Range<Int>] {
    // Build ranges between separator groups
    var ranges: [Range<Int>] = []
    var prevEnd = 0

    for group in groups {
        let start = prevEnd
        let end = group.first!
        if end > start {
            ranges.append(start..<end)
        }
        prevEnd = group.last! + 1
    }

    return ranges
}
```

### 4. Part 1 vs Part 2: Same Structure, Different Reading Direction

The key architectural insight was that **only the number extraction changes** between parts:

| Component | Part 1 | Part 2 |
|-----------|--------|--------|
| `findSeparatorColumns()` | Same | Same |
| `findProblemRanges()` | Same | Same |
| Number extraction | Horizontal (`.integers()`) | Vertical (column-by-column) |

**Part 1** - Read numbers horizontally:
```swift
let numbers = numberRows.flatMap { row in
    row[range].integers()  // AoCTools helper
}
```

**Part 2** - Read numbers vertically (cephalopod math):
```swift
var numbers: [Int] = []

for col in range {
    var digits: [Character] = []

    for row in numberRows {
        let index = row.index(row.startIndex, offsetBy: col)
        let char = row[index]
        if char.isNumber {
            digits.append(char)
        }
    }

    if !digits.isEmpty {
        let num = Int(String(digits))!
        numbers.append(num)
    }
}
```

### 5. AoCTools String Utilities

Leveraged AoCTools for cleaner code:

```swift
// Split input into lines
let lines = input.lines

// Extract integers from a string (handles spacing)
"123 45   6".integers()  // Returns [123, 45, 6]

// String subscript by Range<Int>
let chunk = row[0..<5]  // First 5 characters

// Sum/product on arrays
numbers.sum()
numbers.product()
```

### 6. Prototyping in Python First

Before writing Swift, we validated our approach in Python:

1. Verified the algorithm works on the example
2. Got the expected answer for actual input
3. Identified edge cases (line length differences)

This "prototype first" approach saved debugging time in Swift.

## Interview Takeaways

This puzzle exercised several interview-relevant skills:

### Problem-Solving Framework
1. **Restate the problem** in your own words
2. **Work through examples by hand** before coding
3. **Trace data flow** to understand where changes need to happen
4. **Identify what can be reused** vs what needs to change

### Asking Clarifying Questions
- "Where does this value come from?"
- "What makes these digits become one number vs separate numbers?"
- "What stays the same between Part 1 and Part 2?"

### Code Reuse
Recognizing that the problem structure (separator finding, range creation) stays the same, and only the "inner loop" (number extraction) changes, leads to cleaner, more maintainable code.

## Performance

- Part 1: ~98ms
- Part 2: ~75ms
- Total: ~173ms

Input size: ~3,700 columns wide, 1,000 problems

## Complexity Analysis

**Part 1 & 2**:
- Find separators: O(width × rows)
- Group separators: O(separators)
- Process each problem: O(problems × columns × rows)
- Overall: O(width × rows) where width ≈ 3,700, rows = 5

## Debugging Insights

### Initial Confusion
The Part 2 description was tricky - "read right-to-left one column at a time" initially seemed confusing. Working through the example by hand clarified:
- Each **column** becomes one number
- Digits read **top-to-bottom** = most-to-least significant

### Line Length Mismatch
Input had lines of slightly different lengths (3728 vs 3729 chars). Solution: pad shorter lines with spaces.

```swift
let maxWidth = lines.map(\.count).max() ?? 0
lines = lines.map { line in
    line.count < maxWidth ? line + String(repeating: " ", count: maxWidth - line.count) : line
}
```

## Files Modified

- `Sources/Day06.swift` - Main solution
- `Sources/Day06+Input.swift` - Input data
- `Tests/Day06Tests.swift` - Test cases
- `Sources/Day06-learnings.md` - This file

## When to Use Column-Based Parsing

- Grid problems where relationships span multiple rows
- Input with vertical alignment significance
- Problems where "columns" form logical units
- Any time horizontal parsing doesn't capture the structure

## Pattern: Horizontal vs Vertical Number Reading

**Horizontal** (standard):
```
123 456  → [123, 456]
```

**Vertical** (cephalopod):
```
1 4
2 5  → [12, 45]
3 6
```

This is a useful mental model for grid transformation problems.
