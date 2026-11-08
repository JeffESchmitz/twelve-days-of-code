# Day 04: Printing Department - Learning Notes

**Puzzle**: https://adventofcode.com/2025/day/4

**Completed**: December 4, 2025

## Problem Summary

- **Part 1**: Count accessible paper rolls (@ cells with < 4 neighboring @ cells)
- **Part 2**: Simulate iterative removal - removing rolls changes neighbor counts, making more rolls accessible

**Input**: 140×140 character grid with `@` (paper rolls) and `.` (empty)

## Solutions

- **Part 1**: 1540
- **Part 2**: 8972

## Core Concepts Learned

### 1. Neighbor-Counting Grid Pattern (New Fundamental Pattern!)

**Problem Type**: Given a 2D grid, for each cell, count neighbors meeting criteria.

**Common in AoC**: Cellular automata, flood fill, minesweeper logic, spatial analysis.

```swift
// Core pattern: count neighbors matching condition
let count = point.neighbors(adjacency: .all).count(where: predicate)
```

### 2. AoCTools Grid<Character> Usage

```swift
// Parse grid from input
let grid = Grid.parse(input.split(separator: "\n").map(String.init))

// Iterate all points
for (point, character) in grid.points {
    guard character == "@" else { continue }

    // Get all 8 neighbors
    let neighborPoints = point.neighbors(adjacency: .all)

    // Count neighbors matching criteria (nil-safe lookup)
    let count = neighborPoints.count { grid.points[$0] == "@" }
}
```

**Why AoCTools is Perfect**:
- `Grid.parse()` handles 2D string parsing automatically
- `point.neighbors(adjacency:)` returns all 8 directions
- `grid.points[point]` returns `Character?` - handles out-of-bounds gracefully
- No manual edge/corner detection needed!

### 3. Adjacency Options in AoCTools

```swift
.cardinal  // 4 neighbors: N, S, E, W
.ordinal   // 4 diagonal neighbors: NE, NW, SE, SW
.all       // All 8 neighbors (cardinal + ordinal) ← Used today
```

### 4. Functional Programming with `sequence(state:next:)`

**Key Pattern**: Replace while-loop + accumulator with functional generator.

```swift
func part2() async -> Int {
    let initialRolls = Set(grid.points.filter { $0.value == "@" }.keys)

    return sequence(state: initialRolls) { [self] remainingRolls in
        // Find accessible rolls in current state
        let accessible = remainingRolls.filter { self.isAccessible($0, in: remainingRolls) }

        // Terminate if none accessible
        guard !accessible.isEmpty else { return nil }

        // Update state and return count for this round
        remainingRolls.subtract(accessible)
        return accessible.count
    }
    .reduce(0, +)  // Sum all removal counts
}
```

**Why `sequence(state:next:)` Works Here**:
- Generates values lazily until `nil` returned
- State mutation happens inside closure
- Final `.reduce(0, +)` sums all generated values
- Reads declaratively: "Generate removal counts until done, then sum"

**Comparison with Imperative**:
```swift
// Imperative (what we replaced):
var remainingRolls = initialRolls
var totalRemoved = 0
while true {
    let accessible = findAccessible(remainingRolls)
    guard !accessible.isEmpty else { break }
    remainingRolls.subtract(accessible)
    totalRemoved += accessible.count
}
return totalRemoved
```

Both have identical performance (~175ms), but functional version:
- No mutable `totalRemoved` accumulator
- Clearer termination condition (`return nil`)
- Composable with other sequence operations

### 5. Reusable Helper Functions

**Semantic abstraction** makes code self-documenting:

```swift
/// Count neighbors matching predicate
private func neighborCount(of point: Point, matching predicate: (Point) -> Bool) -> Int {
    point.neighbors(adjacency: .all).count(where: predicate)
}

/// Is roll accessible (< 4 neighbors)?
private func isAccessible(_ point: Point, in rolls: Set<Point>) -> Bool {
    neighborCount(of: point) { rolls.contains($0) } < 4
}
```

**Benefits**:
- `isAccessible` expresses intent, not implementation
- `neighborCount` is reusable across both parts
- Business logic separated from iteration

### 6. Set-Based State Management

```swift
// Use Set<Point> instead of modifying grid directly
var remainingRolls = Set(grid.points.filter { $0.value == "@" }.keys)

// O(1) membership checks
rolls.contains(point)

// Efficient bulk removal
remainingRolls.subtract(accessible)
```

**Why Set over Array?**:
- `.contains()`: O(1) vs O(n)
- Critical when checking neighbors millions of times
- `.subtract()` is also optimized for Set

## Swift Patterns Used

### KeyPath for Map

```swift
.map(\.key)  // Extract keys from dictionary entries
// Equivalent to: .map { $0.key }
```

### Filter + Count Pattern

```swift
// Part 1: functional pipeline
grid.points
    .filter { $0.value == "@" }     // Find paper rolls
    .map(\.key)                      // Extract positions
    .filter { ... }                  // Keep accessible
    .count                           // Final count
```

### Closure Capture with `[self]`

```swift
sequence(state: initialRolls) { [self] remainingRolls in
    // `self` is captured for helper method access
    self.isAccessible($0, in: remainingRolls)
}
```

## Performance Analysis

- **Part 1**: 32ms (single pass through grid)
- **Part 2**: 143ms (iterative simulation, multiple passes)
- **Grid size**: 140 × 140 = 19,600 cells

### Complexity

**Part 1**: O(n) where n = grid cells
- Single iteration through all points
- Each point: O(8) neighbor checks
- Total: O(8n) = O(n)

**Part 2**: O(n × rounds)
- Each round: O(remaining) to find accessible
- Number of rounds depends on grid structure
- In practice: ~35 rounds for this input

## The Simulation Pattern

**When to use**: "Keep doing X until no more changes"

**Structure**:
1. Initialize state (set of remaining items)
2. Loop: Find items meeting condition
3. Apply changes (remove/modify items)
4. Repeat until stable (no items meet condition)

**Examples**:
- Conway's Game of Life
- Flood fill algorithms
- Cellular automata
- Cascading deletions (this problem!)

## Debugging Process

No major bugs - the pattern was clear from problem description. Key insights:
1. Recognized neighbor-counting pattern immediately
2. Identified iterative simulation for Part 2
3. Used Set for efficient state tracking
4. Refactored to functional style after working imperative solution

## Takeaways

1. **AoCTools Grid is powerful** - handles parsing, neighbors, bounds checking
2. **`sequence(state:next:)`** is elegant for iterative simulations
3. **Set<Point>** is essential for efficient spatial membership queries
4. **Neighbor counting** is a fundamental AoC pattern - practice variations
5. **Functional ≠ slow** - same performance with cleaner code

## Related Patterns

- Cellular automata (Conway's Game of Life)
- Flood fill algorithms
- Minesweeper neighbor counting
- Iterative simulation until convergence
- State-based removal cascades

## Files Modified

- `Sources/Day04.swift` - Main solution (functional style)
- `Sources/Day04+Input.swift` - Input data
- `Tests/Day04Tests.swift` - Test cases

## Future Reference

**When you see**:
- "Count neighbors with property X" → Neighbor-counting pattern
- "Keep removing until stable" → Iterative simulation
- "Adjacent cells" → Consider `sequence(state:next:)` for functional approach
- Grid problems → Reach for AoCTools `Grid<Character>` first
