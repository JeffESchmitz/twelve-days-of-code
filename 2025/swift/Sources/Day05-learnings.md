# Day 05: Cafeteria - Learning Notes

**Puzzle**: https://adventofcode.com/2025/day/5

**Completed**: December 10, 2025

## Problem Summary

- **Part 1**: Count how many available ingredient IDs are fresh (fall within any range)
- **Part 2**: Count total unique IDs covered by all fresh ranges (handle overlapping ranges)

**Input**: Two sections separated by blank line:
1. Fresh ID ranges (format: `start-end`)
2. Available ingredient IDs (one per line)

## Solutions

- **Part 1**: 789
- **Part 2**: 343329651880509

## Core Concepts Learned

### 1. PointFree Parsing Library (First Use in 2025!)

This was a great candidate for `swift-parsing` because of the structured input format.

```swift
import Parsing

// Parser for a single range: "start-end" → ClosedRange<Int>
let rangeParser = Parse(input: Substring.self) {
    Int.parser()
    "-"
    Int.parser()
}.map { start, end in start...end }

// Parser for the ranges section (newline-separated)
let rangesParser = Many {
    rangeParser
} separator: {
    "\n"
}

// Parser for the IDs section (newline-separated integers)
let idsParser: some Parser<Substring, [Int]> = Many {
    Int.parser()
} separator: {
    "\n"
}

// Full input parser: ranges, blank line, IDs
let inputParser = Parse {
    rangesParser
    "\n\n"
    idsParser
}

// Usage
let (ranges, ids) = try inputParser.parse(input)
```

**Why PointFree Parsing Works Here**:
- Clear separation of concerns (ranges vs IDs)
- Type-safe transformation (`String` → `ClosedRange<Int>`)
- Composable: small parsers combine into larger ones
- Automatic error reporting with location info

**When to Use PointFree Parsing**:
- ✅ Structured input with clear grammar
- ✅ Multiple data types in input
- ✅ Nested or hierarchical data
- ❌ Simple line-by-line parsing (use `.split()`)
- ❌ Grid/character-based input (use `Grid.parse()`)

### 2. Interval Merging Algorithm (Classic Pattern!)

**Problem**: Count unique elements covered by overlapping ranges.

**Naive approach** (too slow): Create a Set of all IDs → O(n) memory where n = total range coverage

**Optimal approach**: Merge overlapping intervals → O(k log k) where k = number of ranges

```swift
func part2() async -> Int {
    // Step 1: Sort ranges by start value
    let sorted = freshRanges.sorted { $0.lowerBound < $1.lowerBound }

    // Step 2: Merge overlapping/adjacent ranges
    var merged: [ClosedRange<Int>] = []
    for range in sorted {
        if let last = merged.last, last.upperBound >= range.lowerBound - 1 {
            // Overlapping or adjacent - extend the last range
            merged[merged.count - 1] = last.lowerBound...max(last.upperBound, range.upperBound)
        } else {
            // No overlap - add new range
            merged.append(range)
        }
    }

    // Step 3: Sum sizes of merged ranges
    return merged.map { $0.count }.sum()
}
```

**Key Insight**: After sorting by start, we only need to compare with the *last* merged range.

**Merge Condition**: `last.upperBound >= range.lowerBound - 1`
- `>= lowerBound`: Overlapping ranges (share at least one point)
- `>= lowerBound - 1`: Adjacent ranges (e.g., 3-5 and 6-8 become 3-8)

**Visual Example**:
```
Input:  3-5, 10-14, 16-20, 12-18
Sorted: 3-5, 10-14, 12-18, 16-20

Merge process:
  [3-5]                    → add 3-5
  [3-5, 10-14]             → no overlap, add 10-14
  [3-5, 10-18]             → 12-18 overlaps 10-14, extend to 10-18
  [3-5, 10-20]             → 16-20 overlaps 10-18, extend to 10-20

Result: [3-5, 10-20] → 3 + 11 = 14 unique IDs
```

### 3. Swift ClosedRange for Natural Range Modeling

```swift
let freshRanges: [ClosedRange<Int>]

// Creation
let range = 3...5

// Properties
range.lowerBound  // 3
range.upperBound  // 5
range.count       // 3 (includes both endpoints!)

// Containment check
range.contains(4)  // true
range.contains(6)  // false
```

**Why ClosedRange?**
- Matches problem semantics (inclusive ranges)
- Built-in `.count` for size calculation
- `.contains()` for membership testing
- Works with generic algorithms

### 4. Part 1: Simple Range Containment

```swift
func part1() async -> Int {
    ingredientIDs.count { id in
        freshRanges.contains { $0.contains(id) }
    }
}
```

**Complexity**: O(n × m) where n = IDs, m = ranges
- For each ID, check against all ranges
- Could optimize with interval tree for large inputs, but not needed here

## Performance

- Part 1: ~15ms (789 IDs checked against 178 ranges)
- Part 2: ~0.01ms (sort + merge 178 ranges)
- Total: ~15ms

## Complexity Analysis

**Part 1**: O(n × m)
- n = number of ingredient IDs (1000)
- m = number of ranges (178)
- Each ID checked against all ranges

**Part 2**: O(m log m)
- Sorting dominates: O(m log m)
- Single pass merge: O(m)
- Sum calculation: O(merged ranges)

## Swift Patterns Used

### Type Annotation for Parser Disambiguation

```swift
// Without type annotation: ambiguous buildExpression error
let idsParser = Many { Int.parser() } separator: { "\n" }  // ❌

// With type annotation: works!
let idsParser: some Parser<Substring, [Int]> = Many {
    Int.parser()
} separator: {
    "\n"
}  // ✅
```

### In-Place Array Modification

```swift
// Modify last element of array
merged[merged.count - 1] = newRange

// Alternative with removeLast + append (less efficient)
let last = merged.removeLast()
merged.append(newRange)
```

### Functional Count with Predicate

```swift
// Count elements matching condition
ingredientIDs.count { id in
    freshRanges.contains { $0.contains(id) }
}
```

## Debugging Process

No major bugs! The algorithm was straightforward once the pattern was recognized.

**Key realization**: Part 2 doesn't care about the available IDs at all - only the ranges matter.

## Takeaways

1. **PointFree Parsing** is excellent for structured, multi-section input
2. **Interval merging** is a classic algorithm - sort first, then single pass
3. **ClosedRange<Int>** naturally models inclusive ranges with built-in `.count`
4. **Read the problem carefully** - Part 2 ignores Part 1's ID list entirely
5. **Don't create huge Sets** - merge intervals instead for memory efficiency

## Related Patterns

- Interval scheduling / meeting rooms problems
- Range coalescing in database queries
- Segment trees for advanced interval queries
- Sweep line algorithms

## When to Use Interval Merging

- ✅ Count unique elements in overlapping ranges
- ✅ Find gaps between ranges
- ✅ Compress ranges for efficient storage
- ✅ Calendar/scheduling conflicts
- ✅ Memory region management

## Files Modified

- `Sources/Day05.swift` - Main solution with PointFree Parsing
- `Sources/Day05+Input.swift` - Input data (gitignored)
- `Tests/Day05Tests.swift` - Test cases

## Future Reference

**Interval Merging Template**:
```swift
func mergeIntervals(_ intervals: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    guard !intervals.isEmpty else { return [] }

    let sorted = intervals.sorted { $0.lowerBound < $1.lowerBound }
    var merged: [ClosedRange<Int>] = [sorted[0]]

    for range in sorted.dropFirst() {
        if let last = merged.last, last.upperBound >= range.lowerBound - 1 {
            merged[merged.count - 1] = last.lowerBound...max(last.upperBound, range.upperBound)
        } else {
            merged.append(range)
        }
    }

    return merged
}
```
