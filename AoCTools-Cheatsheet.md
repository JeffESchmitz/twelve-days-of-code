# AoCTools Quick Reference

Quick reference for common utilities in the AoCTools package. Check here when implementing solutions if something feels like a generic algorithmic problem.

**Philosophy**: Awareness without rigidity. Most AoC problems need custom solutions by design. Use this for discovery, not prescription.

---

## 📐 Math & Numbers

**Source**: `Int+Utils.swift`

```swift
gcd(_ m: Int, _ n: Int) -> Int          // Greatest common divisor
lcm(_ m: Int, _ n: Int) -> Int          // Lowest common multiple
pow(_ base: Int, _ exponent: Int) -> Int // Integer exponentiation
```

**Common uses**: Modular arithmetic, cycle detection, pattern finding

---

## 📦 Collections

### Array Extensions

**Chunking & Grouping** (`Array+Chunk.swift`):
```swift
array.chunked(by: condition)  // Split into chunks where condition(elem[i], elem[i+1]) is true
array.grouped(by: condition)  // Split into groups separated where condition(elem) is true
```

**Permutations** (`Array+Permutations.swift`):
```swift
array.permutations { permutation in
    // Called with each permutation using Heap's algorithm
}
```

**Statistics** (`Array+Median.swift`):
```swift
array.median()  // Works for BinaryInteger and FloatingPoint
                // Returns middle element or average of two middle elements
```

**Other utilities**:
- `Array+Sort.swift` - Additional sorting utilities
- `Array+Util.swift` - General array helpers
- `Array+Map.swift` - Mapping utilities

### Sequence Extensions

**Counting** (`Sequence+Count.swift`):
```swift
sequence.count(where: predicate)  // Count matching elements
sequence.sumOf(\.property)        // Sum by keypath
sequence.productOf(\.property)    // Product by keypath

// For Int sequences specifically:
[1, 2, 3].sum()                   // -> 6
[1, 2, 3].product()               // -> 6
```

**Min/Max** (`Sequence+MinMax.swift`):
```swift
sequence.min(of: \.property)      // Find min value by keypath
sequence.max(of: \.property)      // Find max value by keypath
sequence.minAndMax(of: \.property) // Both in single pass -> (min, max)?
```

---

## 🗺️ Spatial & Geometry

### Point - 2D Coordinates

**Source**: `Point.swift`

```swift
let p = Point(x, y)
Point.zero                        // (0, 0)

// Operators
p1 + p2, p1 - p2, p * 2          // Arithmetic
p + Direction.n                   // Move in direction

// Distances
p.distance(to: other)             // Manhattan distance (|x1-x2| + |y1-y2|)
p.chebyshevDistance(to: other)    // Chess distance (max of x/y differences)

// Neighbors
p.neighbors(adjacency: .cardinal) // 4 neighbors (N/S/E/W)
p.neighbors(adjacency: .ordinal)  // 4 diagonal neighbors
p.neighbors(adjacency: .all)      // All 8 neighbors

// Movement & Lines
p.moved(to: direction, steps: n)  // Move n steps in direction
p.line(to: end)                   // All points in line (45° angles only)
p.rotated(by: degrees)            // Rotate 90°, 180°, 270°

// Comparison
// Points compare in "reading order" (top to bottom, left to right)
```

### Direction - Cardinal & Ordinal

**Source**: `Direction.swift`

```swift
Direction.n, .s, .e, .w          // Cardinal (also: .up, .down, .left, .right)
Direction.ne, .nw, .se, .sw      // Ordinal (diagonal)

Direction.cardinal               // Array of [n, w, s, e]
Direction.ordinal                // Array of diagonal directions

direction.offset                 // Point offset for this direction
direction.opposite               // Opposite direction
direction.turned(.clockwise, by: 90)      // Turn right
direction.turned(.counterclockwise, by: 90) // Turn left
```

### Grid - 2D Grid Operations

**Source**: `Grid.swift`

```swift
Grid<Value>.parse(string)        // Parse from multiline string
Grid<Value>.parse(lines)         // Parse from array of strings

grid.points                      // [Point: Value] dictionary
grid.xRange, grid.yRange         // ClosedRange<Int> for bounds
grid.draw()                      // Print grid to console
```

### Other Spatial Types

- `Point3` - 3D coordinates with similar operations
- `HexPoint` - Hexagonal grid coordinates
- `Collection+Point` - Collection utilities for Point arrays

---

## 🧠 Algorithms

### A* Pathfinding

**Source**: `AStar.swift`

```swift
protocol Pathfinding {
    associatedtype Coordinate: Hashable = Point
    associatedtype Cost: Numeric & Comparable = Int

    func neighbors(of point: Coordinate) -> [Coordinate]
    func costToMove(from: Coordinate, to: Coordinate) -> Cost
    func distance(from: Coordinate, to: Coordinate) -> Cost
    func goalReached(at: Coordinate, goal: Coordinate) -> Bool // optional
}

// Default implementation for Point grids with manhattan distance
```

**Use case**: Shortest path problems, navigation, maze solving

### Memoization

**Source**: `Memoize.swift`

Two approaches available:

**Function wrapper**:
```swift
let sumOfDigits = memoize(_sumOfDigits)
func _sumOfDigits(_ n: Int) -> Int {
    guard n != 0 else { return 0 }
    return n % 10 + sumOfDigits(n / 10)
}
```

**Memoized class** (for self-referential recursion):
```swift
let sumOfDigits = Memoized<Int, Int> { n, recurse in
    guard n != 0 else { return 0 }
    return n % 10 + recurse(n / 10)
}
```

**Use case**: Dynamic programming, recursive problems with overlapping subproblems

---

## 🏗️ Data Structures

### Stack

**Source**: `Stack.swift`

Standard stack implementation with push/pop/peek.

### CircularBuffer

**Source**: `CircularBuffer.swift`

Fixed-size ring buffer with efficient wraparound.

### Tree & TreeNode

**Source**: `Tree.swift`, `TreeNode.swift`

Generic tree data structures for hierarchical data.

---

## 🛠️ Utilities

### String Extensions

**Source**: `String.swift`

```swift
string.trimmed()                 // Trim whitespace
string.substring(start, length)  // Extract substring
string.indexOf(substr)           // Find index of substring

// Subscripts
string[5]                        // Character at index
string[0...3]                    // Substring by range
string[0..<3]                    // Substring by range

// Parsing
string.lines                     // Split by newlines (preserves empty lines)
string.integers()                // Extract all integers (including negative)
```

**Regex utilities**: See `Regex.swift` for additional pattern matching

### Timer - Performance Measurement

**Source**: `Timer.swift`

```swift
let timer = Timer("2", fun: "'Gift Shop' part 1")
// ... do work ...
timer.show()                     // Prints: "Day 2 'Gift Shop' part 1 took 18.117ms"

Timer.showTotal()                // Show cumulative time
```

**Note**: Already integrated into `run.sh` for automatic timing

### Other Utilities

- `Data.swift` - Binary data utilities
- `Draw.swift` - Drawing/visualization protocols
- `Pair.swift`, `Triple.swift` - Tuple-like types with named fields
- `Set.swift` - Set extensions

---

## ✅ When to Use This Cheatsheet

**Check here when**:
- Something feels like a standard algorithm problem (pathfinding, memoization, etc.)
- You're about to implement basic data structures from scratch
- You need common math operations (GCD, LCM, etc.)
- Working with 2D/3D coordinates or grids
- Doing frequent array/sequence operations

**Examples**:
- "I need to find the shortest path" → Check AStar
- "This recursive function is too slow" → Check Memoize
- "I'm working with a 2D grid" → Check Point, Grid, Direction
- "I need to find GCD" → Check Int+Utils

---

## ❌ When NOT to Force-Fit

**Each AoC problem is intentionally unique by design**. Don't let available tools dictate your approach.

**Red flags**:
- Contorting the problem to use a tool
- Spending more time adapting a utility than solving fresh
- Utility doesn't quite fit but "close enough"

**Remember**:
> "When you have a hammer, everything looks like a nail"

Custom solutions are often clearer, more maintainable, and better matched to the specific problem constraints.

---

## 🎯 The Right Balance

1. **Glance at this list** when starting a problem
2. **Use utilities for obviously generic tasks** (GCD, pathfinding, etc.)
3. **Build custom for everything else** (which is most of AoC)
4. **Extract to AoCTools after solving 3+ times** the same way

Most days will use **zero** AoCTools utilities besides the day framework. And that's perfectly fine!

---

*Last updated: Day 2, 2025*
