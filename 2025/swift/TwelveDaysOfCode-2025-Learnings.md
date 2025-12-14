# Twelve Days of Code 2025 - Learnings & Insights

> **Purpose**: Document techniques, patterns, and insights from Twelve Days of Code 2025 🎄
>
> Building on the framework and learnings from AoC 2024

**Last Updated**: December 14, 2025
**Progress**: Days 1-12 (10 solved so far, 20 stars)

---

## Table of Contents

- [Quick Reference: Days 1-12](#quick-reference-days-1-12)
- [Development Environment](#development-environment)
- [Common Patterns & Algorithms](#common-patterns--algorithms)
- [Swift Toolbox](#swift-toolbox)
- [Debugging Strategies](#debugging-strategies)
- [Problem-Solving Framework](#problem-solving-framework-breaking-down-word-problems)
- [Deep Dives](#deep-dives)
- [Preparation and Strategy](#preparation-and-strategy)

---

## Quick Reference: Days 1-12

| Day | Title | Key Technique | Complexity |
|-----|-------|---------------|------------|
| 1 | Secret Entrance | Simulation + Modular Arithmetic | ⭐⭐ Easy |
| 2 | Gift Shop | Arithmetic Pattern Detection + Performance Profiling | ⭐⭐ Medium |
| 3 | Lobby | Greedy Optimization + Monotonic Stack | ⭐⭐ Medium |
| 4 | Printing Department | Neighbor-Counting Grid + Iterative Simulation | ⭐⭐ Medium |
| 5 | Cafeteria | PointFree Parsing + Interval Merging | ⭐⭐ Medium |
| 6 | Trash Compactor | Column-Based Grid Parsing | ⭐⭐ Easy |
| 7 | Laboratories | Set vs Dict (merge vs accumulate) + Pre-parsed O(1) lookups | ⭐⭐ Medium |
| 8 | Playground | Union-Find (Disjoint Set Union) + Kruskal's MST | ⭐⭐ Medium |
| 9 | Movie Theater | Ray Casting + Polygon Containment | ⭐⭐ Medium |
| 10 | Factory | Integer Linear Programming + Gaussian Elimination | ⭐⭐ Hard |
| 11 | TBD | TBD | ⭐ TBD |
| 12 | TBD | TBD | ⭐ TBD |

---

## Development Environment

### VSCode Setup

**What We Have:**

- Complete Swift development environment in VSCode
- Debug configurations with breakpoints
- Fast testing workflow (`./test <day>` for incremental compilation)
- Testing UI vs command-line trade-offs

**Key Files:**

- `.vscode/launch.json` - Debug configurations
- `.vscode/tasks.json` - Build and test tasks
- `.vscode/settings.json` - Swift extension config
- `.vscode/USAGE.md` - Complete usage guide

**Testing Performance:**

- **VSCode Testing UI (beaker)**: Slower (full rebuild) but convenient for exploration
- **Command-line `./test <day>`**: Fast (incremental compilation) - use for iteration
- **Recommendation**: Use `./test` for rapid development, beaker for test discovery

**Debugging:**

- Set breakpoints: Click line number gutter
- `F5` to start debugging
- `F10` (step over), `F11` (step into), `Shift+F11` (step out)

### Development Workflow

```bash
# Fast iteration cycle
./run <day>      # Run specific day
./test <day>     # Test specific day (uses cache)
./input.sh <day> # Download puzzle input
```

---

## Common Patterns & Algorithms

### Search Algorithms

#### Breadth-First Search (BFS)

**When to use**: Finding shortest paths, exploring level-by-level, finding minimum values

**Template**:

```swift
import Collections

var queue = Deque<Int>()
queue.append(startValue)

while let current = queue.popFirst() {
    // Process current
    // Add neighbors to queue
    for neighbor in getNeighbors(current) {
        queue.append(neighbor)
    }
}
```

**Why Deque?** O(1) `popFirst()` vs Array's O(n)

#### Pattern: Working Backwards

When output depends on input consumption (like dividing by 8), work backwards:
1. Start with values that produce the final output
2. Extend by trying all possible inputs that could lead there
3. BFS naturally finds minimum solutions

### Virtual Machine Implementation

**Pattern**:

```swift
struct Computer {
    var registers: [String: Int]
    var instructionPointer: Int
    var program: [Int]

    mutating func run() {
        while instructionPointer < program.count - 1 {
            let opcode = program[instructionPointer]
            let operand = program[instructionPointer + 1]
            executeInstruction(opcode, operand)
        }
    }
}
```

**Key Lessons**:

- Check bounds for both opcode AND operand
- Handle jumps carefully (don't double-increment)
- Use `mutating func` for state changes
- Struct-based design is clean for VM state

### Parsing Patterns

**Swift Parsing Library** (Point-Free):

```swift
struct Parser: Parser {
    var body: some Parser<Substring, Output> {
        Parse(Constructor.init) {
            Int.parser()
            Whitespace()
            // ... more parsers
        }
    }
}
```

**Watch out**: `split(separator:)` skips empty lines!

---

## Swift Toolbox

### Collections Package

**Deque** - Essential for efficient queues

```swift
import Collections

var queue = Deque<Int>()
queue.append(item)        // O(1)
let first = queue.popFirst()  // O(1) - Array is O(n)!
```

**When to use**: BFS, queues, any FIFO operations

### Functional Patterns

**zip + reduce**:

```swift
// Compare two sorted lists
zip(left, right).reduce(0) { $0 + abs($1.0 - $1.1) }
```

**enumerated + filter + map**:

```swift
// Remove element at specific index
array.enumerated()
    .filter { $0.offset != index }
    .map { $0.element }
```

**allSatisfy**:

```swift
differences.allSatisfy { abs($0) >= 1 && abs($0) <= 3 }
```

### Bit Manipulation

**Building values bit-by-bit**:

```swift
let candidateA = (currentA << 3) | bits  // Prepend 3 bits
```

Useful for:
- Working with binary representations
- Building numbers incrementally
- Reverse engineering bit-based algorithms

### String/Sequence Operations

```swift
.split(separator:)    // Skips empty elements!
.prefix(n)           // First n elements
.suffix(from: index) // Elements from index to end
.joined(separator:)  // Combine with delimiter
```

---

## Debugging Strategies

### The Systematic Approach

1. **Start with example input**: Test cases catch issues early
2. **Index out of bounds?**
   - Check loop conditions (`< count` vs `< count - 1`)
   - Verify you're not accessing `array[i+1]` past the end
3. **Unexpected behavior?**
   - Add print statements for intermediate values
   - Use debugger to step through execution
4. **Double operations?**
   - Check if both function AND caller are doing the same thing
   - Example: Jump instruction incrementing IP, then main loop also incrementing

### Common Swift Gotchas

1. **split() behavior**: Omits empty elements
2. **Integer division**: No implicit rounding, but uses floor division
3. **Mutating functions**: Need `mutating` keyword for struct methods
4. **Array bounds**: Swift crashes on out-of-bounds, no silent errors

### Print Debugging Pattern

```swift
print("Current state: A=\(registerA), B=\(registerB), IP=\(instructionPointer)")
```

For complex state, consider making types `CustomStringConvertible`

---

## Problem-Solving Framework: Breaking Down Word Problems

This systematic approach helps identify key information in AoC puzzles and determine the right algorithm and data structures to use.

### The 8-Step Problem Breakdown Process

#### Step 1: Identify the GOAL
**Question**: What are we solving for? What's the final answer?

**Example**: "What is the minimum number of steps needed to reach the exit?"
- Output: A single integer (number of steps)
- This word "minimum" hints at: BFS, Dijkstra, or dynamic programming

#### Step 2: Understand the WORLD
**Question**: What's the environment/space we're working in?

**Example**:
- 2D grid: 71×71 (coordinates 0-70)
- Start point: (0,0)
- End point: (70,70)
- Visual representation helps: Draw the grid mentally or on paper

#### Step 3: Identify the CONSTRAINTS
**Question**: What are the rules? What's NOT allowed?

**Example**:
- Movement: Only 4 directions (no diagonals!)
- Boundaries: Must stay within 0-70 in both dimensions
- Obstacles: Cannot enter corrupted coordinates
- Timing: Use FIRST 1024 bytes only (not all input!)

⚠️ **Critical**: Read for "only", "first", "at most", "exactly" - these are constraint boundaries

#### Step 4: Understand the INPUT
**Question**: How is data provided? What format? What order?

**Example**:
- Format: "X,Y" (not "Y,X" - order matters!)
- One coordinate per line
- In chronological order (byte 1, byte 2, ...)
- Must parse carefully - wrong order means wrong answer

#### Step 5: Trace the EXAMPLE
**Question**: Can we manually walk through a small example?

**Purpose**: Validates our understanding before implementing

**Key insight**: Examples often reveal that parameters are CONFIGURABLE
- Grid size: 7 for test, 71 for real
- Byte count: 12 for test, 1024 for real
- Implementation must support both!

#### Step 6: Recognize the ALGORITHM PATTERN
**Question**: What CS pattern does this match?

**Pattern recognition hints**:
- "minimum number of steps" → BFS, Dijkstra, or DP
- "count all ways" → Dynamic programming or DFS
- "find if possible" → BFS, graph search
- "optimize by choosing" → Greedy or DP
- "can reach any?" → BFS/flood fill
- "ordered/dependency" → Topological sort

#### Step 7: Identify EDGE CASES and GOTCHAS
**Question**: What could go wrong? What's easy to get wrong?

**Common gotchas**:
- Coordinate system confusion (x,y vs row,col)
- Off-by-one errors (0-70 means 71 elements!)
- Order sensitivity (is sequence important?)
- Impossible states (what if no solution exists?)
- Input parsing mistakes (extra whitespace, wrong separator)

#### Step 8: Plan the DATA STRUCTURES
**Question**: What data structures best represent this problem?

**Example**:
- **Locations**: `Set<Point>` (O(1) lookups)
- **BFS queue**: `Deque<(Point, Int)>` (O(1) append and popFirst)
- **Visited tracking**: `Set<Point>` (O(1) membership test)
- **Input**: `[Point]` or parsed array (ordered matters)

See "Data Structure Selection Criteria" section below.

### The Three-Phase Architecture Pattern 🏗️

**A Holistic Problem-Solving Approach**

A powerful pattern for approaching complex AoC problems. This is a **meta-pattern** that appears across multiple problems and elegantly handles complexity scaling.

#### The Three Phases Explained

**Phase 1: Precompute (One-Time Setup)**
- Do expensive work ONCE, then reuse it forever
- Example: BFS all button pairs on keypads, store all results
- Result: "I know how to get from any button to any other button"
- Time investment: Usually small, but pays dividends

**Phase 2: Optimize for Current Problem**
- With precomputed knowledge, solve the specific problem optimally
- Example: Given code "029A", find the BEST numeric keypad sequence
- Not just "a" shortest path, but THE optimal one considering downstream costs
- Uses Phase 1 data to make smart, informed choices

**Phase 3: Calculate Final Answer (Leverage Everything)**
- Recursively apply optimization through all layers/iterations
- Example: Calculate what YOU have to type given the optimal numeric sequence
- Memoization prevents re-solving identical sub-problems
- By scaling up (depth 2 → depth 25), reuse cached answers millions of times

#### How This Pattern Scales

```
WITHOUT the three-phase approach:
  Part 1 (depth 2): Complex, requires careful path selection
  Part 2 (depth 25): Completely different problem, maybe impossible

WITH the three-phase approach:
  Part 1: Implement phases 1, 2, 3 with depth=2
  Part 2: Change ONE LINE (depth=2 → depth=25)
  Result: Same code, massively scaled, still fast
```

#### Key Insight: Separating Concerns

By dividing into **three distinct phases**, you:

1. **Separate concerns** - Setup, optimization, scaling are independent
2. **Identify bottlenecks** - Which phase is expensive? Optimize that ONE phase
3. **Enable reuse** - Phase 1 output serves all subsequent phases
4. **Build confidence** - Validate each phase independently before combining
5. **Scale elegantly** - Phase 3 can handle massive scale because phases 1 & 2 are efficient
6. **Transfer knowledge** - Same structure works for many different problems

#### When to Apply This Pattern

Look for these signs that a three-phase approach will help:
- ✅ Part 1 and Part 2 are "the same problem with different parameters"
- ✅ One part requires expensive precomputation (pathfinding, parsing, analysis)
- ✅ The same sub-problems repeat across multiple iterations
- ✅ Scaling up (larger numbers, more layers) would be infeasible without caching
- ✅ Multiple "equally good" solutions exist, but some have better properties

---

### Key Information Extraction Checklist

Use this checklist when reading any AoC problem:

✅ **Goal**: What's the final answer we need? (number, coordinate, string, etc.).  
✅ **World**: What space/environment? (grid, graph, list, etc.).  
✅ **Start/End**: Where do we begin? Where do we finish?  
✅ **Rules**: How can we move/act? What transitions are allowed?  
✅ **Obstacles**: What blocks us or prevents certain actions?  
✅ **Input format**: How is data provided? (lines, grid, comma-separated, etc.).  
✅ **Critical numbers**: Any magic numbers? (1024, 50, etc.) Are they exact or   approximate?  
✅ **Example**: Can we trace through the example? Do we get expected answer?    
✅ **Algorithm**: What CS pattern fits this problem?  
✅ **Edge cases**: What could break our solution? (empty input, no solution, boundary conditions).   

---

### Data Structure Selection Criteria

When choosing between similar data structures:

#### 1. Access Patterns
- **Read-heavy**: Set or Dictionary (O(1) lookup)
- **Write-heavy**: Deque or Array (efficient append)
- **Both**: Depends on frequency; profile if needed

#### 2. Operation Performance
Compare the cost of critical operations:

```swift
// Example: Checking if a point is corrupted
// Array: O(n) - bad when called millions of times
let corrupted: [Point]
if corrupted.contains(point) { } // O(n) ❌

// Set: O(1) - perfect for membership testing
let corrupted: Set<Point>
if corrupted.contains(point) { } // O(1) ✅
```

#### 3. Semantic Fit
Choose structures that match your mental model:

```swift
// Queue operations: Deque vs Array
let queue = Deque<Item>()
queue.append(item)        // O(1)
let first = queue.popFirst() // O(1) ✅

// vs Array (slow!)
var queue = [Item]()
queue.append(item)        // O(1)
let first = queue.removeFirst() // O(n) ❌
```

#### 4. Simplicity Principle
**Rule**: Use the simplest structure that meets your needs

```swift
// Don't over-engineer:
// If Set works, don't use Dictionary with Bool values
// If Array is fast enough, don't add complexity

// Data structure complexity spectrum:
Array < Set < Dictionary < Custom Types
```

#### 5. Memory Considerations
Sometimes size matters:

```swift
// Set vs Array for 1000 unique points
// Set: ~32KB (hash storage overhead)
// Array: ~16KB (simpler)
// Difference: Usually negligible vs speed gains

// Rule of thumb: Choose for speed first, optimize memory if needed
```

---

### Algorithm Selection Guide

Use the problem breakdown to identify the algorithm:

| Keywords | Algorithm | Example |
|----------|-----------|---------|
| "minimum path", "shortest" | BFS, Dijkstra | Pathfinding |
| "first X that", "blocks path" | Binary search (monotonic) | Finding thresholds |
| "all ways", "count paths" | DP, DFS | Counting combinations |
| "optimize/maximize" | DP, Greedy | Optimization |
| "ordered by dependencies" | Topological sort | Dependency chains |
| "simulate forwards" | Simulation | State tracking |
| "find reverse input" | BFS backwards | Reverse engineering |
| "area/perimeter" | Flood fill, graph traversal | Region analysis |

---

### 🌟 Composite Algorithm Patterns: BFS + Binary Search

One of the most elegant patterns is the **composition of two algorithms** to solve two-part problems efficiently.

#### The Pattern

**Part 1**: Solve with a base algorithm (e.g., BFS for pathfinding)
**Part 2**: If monotonic property exists, use binary search to call Part 1's algorithm O(log n) times instead of O(n)

#### Why This Works

```
After N operations: Condition false ❌
After N+1 operations: If true, STAYS true ✅ (monotonic property!)
After N+2 operations: Still true ✅
```

Once a condition becomes true (or false), it never reverses. This irreversible property enables binary search.

#### The Code Elegance

```swift
// Part 1: Core algorithm
func solve(parameter: Int) -> Int {
    // Algorithm implementation
    return result  // or -1 if no solution
}

// Part 1 wrapper
func part1() async -> Int {
    solve(parameter: 1024)
}

// Part 2: Binary search calls Part 1 repeatedly
func part2() async -> Int {
    var left = 0
    var right = maxValue - 1

    while left < right {
        let mid = (left + right) / 2
        if solve(parameter: mid + 1) >= 0 {
            left = mid + 1  // Condition met, search higher
        } else {
            right = mid     // Condition not met, search lower
        }
    }

    return left
}
```

#### When to Look for This Pattern

1. **Part 1**: Solves a problem with clear algorithm
2. **Part 2**: Asks for "first X that" or "when does Y happen?"
3. **Monotonic property**: Once a condition is true/false, it stays that way
4. **Constraint**: Parameters vary between example and real input

---

## Deep Dives

### Day 1: Secret Entrance

**The Challenge**: Track a circular dial (positions 0-99) starting at 50. Follow rotation instructions (L/R with distance) and count how many times the dial lands on position 0.

**Key Insights**:

1. **Algorithm Pattern: Simulation**
   - Follow instructions sequentially
   - Track state (position) through each step
   - Count occurrences of target condition (position == 0)

2. **Wraparound Mechanics**
   - Circular dial means position wraps: 0 ↔ 99
   - Two implementation approaches:
     - **If-statements** (chosen): Readable, debuggable
       ```swift
       if position < 0 { position += 100 }
       else if position > 99 { position -= 100 }
       ```
     - **Modulo formula**: Mathematically elegant but harder to reason about
       ```swift
       position = ((position % 100) + 100) % 100
       ```

3. **Data Structure Choice**
   - `struct Rotation { let direction: Character; let distance: Int }`
   - Simple, clear, and type-safe
   - Alternative considered: Tuple with named arguments (less clear)

4. **Parsing Strategy**
   - Used simple Swift string operations: `split(separator:)` + `compactMap`
   - Could use swift-parsing, but overkill for simple format
   - **Key**: `compactMap` filters out empty lines automatically

5. **Edge Cases**
   - Empty input → return 0
   - Large rotations (e.g., L500) → arithmetic handles correctly, no loops needed
   - Starting position (50) is never 0, so no initial count

**Implementation Highlights**:

```swift
// Simple, readable simulation loop
var position = 50
var count = 0

for rotation in rotations {
    // Apply movement
    if rotation.direction == "L" {
        position -= rotation.distance
    } else {
        position += rotation.distance
    }

    // Handle wraparound
    if position < 0 {
        position += 100
    } else if position > 99 {
        position -= 100
    }

    // Check if we landed on zero
    if position == 0 {
        count += 1
    }
}
```

**Learning Mode Experience**:

Used Puzzle Teacher approach (Socratic method) to discover the solution through guided questioning:
- Traced example manually to understand mechanics
- Discovered wraparound behavior by working through calculations
- Chose if-statement approach for readability over modulo formula
- Built understanding of simulation as the right algorithm pattern

**Performance**: O(n) where n is number of rotation instructions. Fast and straightforward.

**Answers**:
- Part 1: 1145
- Part 2: 6561

---

### Day 2: Gift Shop

**The Challenge**: Analyze product IDs to find patterns where digits repeat in sequence (e.g., 123123 has "123" repeated twice). Count products with exactly 2 repetitions, then find sum of IDs with at least 2 repetitions.

**Key Insights**:

1. **Arithmetic Pattern Detection (No String Conversion)**
   ```swift
   // Extract last k digits
   let pattern = number % POW10[k]

   // Extract first k digits
   let upperHalf = number / POW10[k]

   // Reconstruct by repeating
   var reconstructed = 0
   for _ in 0..<repeatCount {
       reconstructed = reconstructed * divisor + pattern
   }
   ```

2. **Performance Optimization with Precomputation**
   ```swift
   private let POW10: [Int] = {
       var powers = [Int](repeating: 1, count: 19)
       for i in 1..<powers.count {
           powers[i] = powers[i - 1] * 10
       }
       return powers
   }()
   ```
   - O(1) lookup instead of repeated `pow()` calls
   - Computed once at program start

3. **Leading Zero Detection**
   ```swift
   // Pattern must have correct digit count
   guard pattern >= POW10[patternLength - 1] else { continue }
   ```
   - Prevents false matches like "01" being treated as "1"

4. **Performance-Aware Functional Programming**

   **When Functional Wins** ✅:
   ```swift
   // Top-level pipeline (12% FASTER than nested loops!)
   ranges
       .flatMap { $0.start...$0.end }
       .filter(isExactlyTwoCopies)
       .sum()
   ```

   **When Functional Loses** ❌:
   ```swift
   // Hot-path inner loop (24% slower with .reduce())
   // Use manual loop instead:
   var reconstructed = 0
   for _ in 0..<repeatCount {
       reconstructed = reconstructed * divisor + pattern
   }
   ```

5. **The .lazy Performance Trap** ⚠️
   - `.lazy` was 25x SLOWER (1567ms vs 63ms)
   - Closure overhead on every element access
   - Only use for infinite sequences or massive datasets
   - **Never use in hot paths**

**Refactoring Lessons - Scientific Method**:
1. Establish baseline (62.8ms)
2. One change at a time
3. Benchmark after each step
4. Revert if >20% regression

**Outcome**:
- ✅ part1/part2: Functional (12% faster)
- ❌ isRepeatedAtLeastTwice inner loop: Reverted to manual (21% faster)

**Rule of Thumb**:
- Outer loops with large data → Functional
- Inner loops called millions of times → Manual

**Swift Techniques**:
- Precomputation with lazy globals
- Range flattening: `.flatMap { $0.start...$0.end }`
- AoCTools `.sum()` for clean pipelines
- Guard-heavy validation pattern

**Related patterns**: Digit manipulation, pattern detection, performance profiling

**Answers**:
- Part 1: 24043483400
- Part 2: 38262920235

---

### Day 3: Lobby

**The Challenge**: Select batteries from banks to maximize joltage output. Part 1 selects 2 batteries to form a 2-digit number. Part 2 selects 12 batteries to form a 12-digit number. Must preserve positional order ("in order" constraint).

**Key Insights**:

1. **Positional Constraint Changes Algorithm**
   - "In order" means: If picking position `i` first, can only pick position `j` where `j > i`
   - Cannot rearrange digits - order must be preserved
   - This constraint fundamentally determines which algorithm to use

2. **Part 1: Suffix Maximum Optimization**
   ```swift
   // One-pass backwards scan with temporary variable
   var maxJoltage = 0
   var maxSoFar = bank[bank.count - 1]  // Start with rightmost

   for i in stride(from: bank.count - 2, through: 0, by: -1) {
       let joltage = bank[i] * 10 + maxSoFar
       maxJoltage = max(maxJoltage, joltage)
       maxSoFar = max(maxSoFar, bank[i])
   }
   ```
   - **Complexity**: O(n) time, O(1) space
   - **Strategy**: For each position as tens digit, pair with max from remaining positions
   - **Optimization**: Single backwards pass maintains running maximum

3. **Part 2: Monotonic Stack (Greedy Selection)**
   ```swift
   var skip = n - keep  // Remove (n-12) smallest digits
   var stack: [Int] = []

   for digit in bank {
       // Greedily remove smaller digits from stack
       while !stack.isEmpty && skip > 0 && stack.last! < digit {
           stack.removeLast()
           skip -= 1
       }
       stack.append(digit)
   }

   // Remove remaining skips from end
   while skip > 0 {
       stack.removeLast()
       skip -= 1
   }
   ```
   - **Complexity**: O(n) time, O(k) space where k=12
   - **Pattern**: Classic "Remove K Digits" problem
   - **Strategy**: Build result by keeping larger digits, removing smaller ones strategically

4. **Algorithm Selection by Problem Type**
   - **Part 1**: "Pick 2, maximize pairing" → Suffix maximum
   - **Part 2**: "Pick 12, remove smallest" → Monotonic stack
   - Same problem domain, different k value requires different algorithm!

5. **Swift stride() for Backwards Iteration**
   ```swift
   stride(from: count - 2, through: 0, by: -1)  // Includes 0
   stride(from: count - 2, to: -1, by: -1)      // Equivalent

   // Alternative:
   (0...count - 2).reversed()
   ```

6. **Socratic Method for Problem Discovery**
   - Started with questions about constraints
   - Discovered "in order" rule through examples
   - Identified optimization opportunities before coding
   - Led to optimal algorithm choice for each part

**Performance**:
- Part 1: 1.3ms (O(n) per bank, 197 banks)
- Part 2: 8.0ms (O(n) per bank with stack operations)
- Total: 9.3ms ⚡

**Complexity Analysis**:
- **Naive Part 1**: O(n²) - try all pairs
- **Optimized Part 1**: O(n) - suffix maximum precomputation
- **Part 2**: O(n) - single pass with stack (amortized)

**Swift Techniques**:
- `stride(from:through:by:)` for backwards iteration
- `.compactMap { $0.wholeNumberValue }` for digit parsing
- `.reduce(0) { $0 * 10 + $1 }` for integer reconstruction
- Guard clauses for edge cases (banks with < k batteries)

**Related Patterns**:
- Greedy algorithms
- Monotonic stack/queue
- Suffix array optimizations
- "Remove K Elements" variants

**Learning Framework Applied**:
- 8-Step Problem Breakdown (GOAL, WORLD, CONSTRAINTS, etc.)
- Socratic questioning to discover constraints
- Algorithm selection based on problem structure
- One-pass optimization considerations

**Answers**:
- Part 1: 17613
- Part 2: 175304218462560

---

### Day 4: Printing Department

**The Challenge**: Count accessible paper rolls in a grid (Part 1), then simulate iterative removal where removing rolls changes neighbor counts and makes more rolls accessible (Part 2).

**Key Insights**:

1. **Neighbor-Counting Grid Pattern (New Fundamental Pattern!)**
   - **Problem Type**: Given a 2D grid, for each cell, count neighbors meeting criteria
   - **Common in AoC**: Cellular automata, flood fill, minesweeper logic, spatial analysis
   - **This Problem**: Count `@` cells with < 4 neighboring `@` cells (out of 8 possible)

2. **AoCTools Grid<Character> Usage**
   ```swift
   // Parse grid from input
   let grid = Grid.parse(input.split(separator: "\n").map(String.init))

   // Iterate all points
   for (point, character) in grid.points {
       guard character == "@" else { continue }

       // Get all 8 neighbors (N, NE, E, SE, S, SW, W, NW)
       let neighborPoints = point.neighbors(adjacency: .all)

       // Count neighbors matching criteria
       let count = neighborPoints.count { neighborPoint in
           grid.points[neighborPoint] == "@"  // nil-safe lookup
       }
   }
   ```

   **Why AoCTools is Perfect Here**:
   - `Grid.parse()` handles 2D string parsing automatically
   - `point.neighbors(adjacency:)` returns all 8 directions
   - `grid.points[point]` returns `Character?` - handles out-of-bounds gracefully
   - No manual edge/corner detection needed!

3. **Part 1: Simple Neighbor Count** (O(n) where n = grid cells)
   ```swift
   func part1() -> Int {
       var accessibleCount = 0
       for (point, character) in grid.points {
           guard character == "@" else { continue }
           let neighbors = point.neighbors(adjacency: .all)
           let rollCount = neighbors.count { grid.points[$0] == "@" }
           if rollCount < 4 {
               accessibleCount += 1
           }
       }
       return accessibleCount
   }
   ```

4. **Part 2: Iterative Removal Simulation** (O(n × rounds))
   - **Key Insight**: Removing rolls changes neighbor counts for remaining rolls
   - **Pattern**: Cascading/iterative simulation until stable state

   ```swift
   func part2() -> Int {
       // Track remaining rolls as Set for O(1) lookups
       var remainingRolls = Set(grid.points.filter { $0.value == "@" }.keys)
       var totalRemoved = 0

       while true {
           // Find accessible in CURRENT state
           let accessible = remainingRolls.filter { point in
               let neighbors = point.neighbors(adjacency: .all)
               let count = neighbors.count { remainingRolls.contains($0) }
               return count < 4
           }

           // No more accessible? Done!
           guard !accessible.isEmpty else { break }

           // Remove all accessible rolls this round
           for point in accessible {
               remainingRolls.remove(point)
           }

           totalRemoved += accessible.count
       }

       return totalRemoved
   }
   ```

5. **Set-Based State Management**
   - Use `Set<Point>` instead of modifying grid directly
   - O(1) for `.contains()` checks during neighbor counting
   - Efficient removal with `.remove()`
   - Cleaner than mutating the original grid structure

6. **Simulation Pattern Recognition**
   - **When to use**: "Keep doing X until no more changes"
   - **Examples**: Conway's Game of Life, flood fill, cellular automata
   - **Structure**: Initialize state → Loop: find changes → apply changes → repeat until stable

**Performance**:
- Part 1: 32ms (single pass through grid)
- Part 2: 440ms (iterative simulation, multiple passes)
- Grid size: 140 rows × 140 columns = 19,600 cells

**Complexity Analysis**:
- **Part 1**: O(n) where n = grid cells
  - Single iteration through all points
  - Each point: O(8) neighbor checks
  - Total: O(8n) = O(n)

- **Part 2**: O(n × rounds)
  - Each round: O(n) to find accessible + O(accessible) to remove
  - Number of rounds depends on grid structure
  - Worst case: O(n²) if removing 1 roll per round
  - Actual: O(n × log n) for typical cascading removal

**Swift Techniques**:
- `Grid<Character>` from AoCTools for 2D parsing
- `Point.neighbors(adjacency: .all)` for directional neighbors
- `Set<Point>` for efficient state tracking
- `.filter { }` with closure for accessibility check
- Guard clauses for early exit

**Related Patterns**:
- Cellular automata (Conway's Game of Life)
- Flood fill algorithms
- Minesweeper neighbor counting
- Iterative simulation until convergence
- State-based removal cascades

**Neighbor-Counting Adjacency Options**:
```swift
.cardinal  // 4 neighbors: N, S, E, W
.ordinal   // 4 diagonal neighbors: NE, NW, SE, SW
.all       // All 8 neighbors (cardinal + ordinal) ← Used today
```

**When to Use This Pattern**:
- ✅ Counting neighbors in 2D grids
- ✅ Spatial analysis (minesweeper, cellular automata)
- ✅ Iterative removal/addition based on neighbor state
- ✅ Flood fill with conditions
- ✅ Grid-based game mechanics

**Answers**:
- Part 1: 1540
- Part 2: 8972

---

### Day 7: Laboratories

**The Challenge**: A tachyon beam enters a manifold at position `S` and travels downward. When it hits a splitter (`^`), the beam stops and two new beams emerge (left and right). Part 1 counts splits; Part 2 counts distinct "timelines" (quantum interpretation where paths don't merge).

**Key Insights**:

1. **The Data Structure IS the Algorithm**

   The critical difference between Part 1 and Part 2 comes down to **one data structure choice**:

   | Part | Data Structure | Behavior | What We Count |
   |------|---------------|----------|---------------|
   | Part 1 | `Set<Int>` | Beams in same column **merge** | Total splits |
   | Part 2 | `[Int: Int]` | Timelines in same column **stay separate** | Total timelines |

   **Part 1 - Beams Merge**:
   ```
   Column 7 has a beam + Column 7 gets another beam = Column 7 has 1 beam
   Set automatically deduplicates!
   ```

   **Part 2 - Timelines Don't Merge**:
   ```
   Column 7 has 1 timeline + Column 7 gets 1 timeline = Column 7 has 2 timelines
   Dictionary tracks the COUNT at each column
   ```

2. **Row-by-Row Simulation Pattern**
   ```swift
   // Both parts use identical simulation logic:
   1. Start with initial state at S's column
   2. For each row (going downward):
      - For each active position:
        - If splitter (^): split left/right
        - Else: continue downward
      - Remove positions that went off edges
   3. Return final count
   ```

3. **Swift String Indexing is O(n), Not O(1)!**

   In the baseline code:
   ```swift
   let charIndex = line.index(line.startIndex, offsetBy: col)
   let char = line[charIndex]
   ```

   Swift has to **walk through the string from the beginning** to find position `col`. Why? Because Swift strings use Unicode grapheme clusters (emoji like 👨‍👩‍👧‍👦 are single "characters"), so it can't just jump to byte offset `col`.

4. **Pre-Parsing Optimization (73% Faster!)**

   **Before** (O(n) string indexing in hot loop):
   ```swift
   if line[charIndex] == "^" { ... }
   ```

   **After** (O(1) Set lookup in hot loop):
   ```swift
   // During init - do string work once
   let splitters: [Set<Int>] = lines.map { line in
       var cols = Set<Int>()
       for (idx, char) in line.enumerated() where char == "^" {
           cols.insert(idx)
       }
       return cols
   }

   // During simulation - fast Set lookup
   if rowSplitters.contains(col) { ... }
   ```

   This is a classic optimization: **precompute expensive operations, use O(1) lookups at runtime**.

5. **Performance Benchmarks**

   We tested multiple implementation approaches:

   | Approach | Total Time | vs Baseline |
   |----------|------------|-------------|
   | Baseline (imperative) | 2.503ms | — |
   | Higher-order reduce/flatMap | 3.56ms | **42% slower** |
   | Optimized functional (no intermediate arrays) | 2.033ms | **19% faster** |
   | **Pre-parsed splitters** | **0.685ms** | **73% faster** |

6. **Why Higher-Order Functions Were Slower**

   The `reduce`/`flatMap` version created intermediate arrays:
   ```swift
   // Creates temporary [(Int, Int)] array, then reduces it
   let updates = timelines.flatMap { (col, count) -> [(Int, Int)] in
       return line[charIndex] == "^"
           ? [(col - 1, count), (col + 1, count)]
           : [(col, count)]
   }
   timelines = updates.reduce(into: [:]) { ... }
   ```

   Each iteration allocates and deallocates throwaway collections. The imperative version modifies dictionaries in place with no allocations.

**Pattern Recognition - "Merge vs. Don't Merge"**:

This is a common pattern in AoC problems:

| Scenario | Use | Example |
|----------|-----|---------|
| "How many unique X?" | `Set` | Unique positions visited |
| "How many total X?" | `Dictionary` with counts | Total paths, timelines |
| "Does X exist?" | `Set.contains()` | Is position blocked? |
| "How many X at each Y?" | `Dictionary` | Count per category |

**Swift Techniques**:
- `dict[key, default: 0] += count` for safe accumulation
- `Set<Int>` for O(1) membership testing
- `line.enumerated()` for index + character iteration
- Pre-parsing into efficient lookup structures

**Key Takeaways**:
1. **Data structure choice determines behavior** - Set vs Dictionary completely changes the semantics
2. **Read Part 2 carefully** - The "quantum" twist meant paths don't merge
3. **Track counts, not individuals** - When numbers get huge, aggregate!
4. **Same algorithm, different accounting** - Both parts use identical simulation logic
5. **Swift String indexing is O(n)** - Pre-parse to avoid string operations in hot loops

**Answers**:
- Part 1: 1,626 splits
- Part 2: 48,989,920,237,096 timelines

---

### Day 8: Playground

**The Challenge**: Connect junction boxes in 3D space by finding closest pairs. Boxes in the same circuit don't need reconnecting. Part 1 processes 1000 pairs; Part 2 connects until all boxes form one circuit.

**Key Insights**:

1. **Union-Find (Disjoint Set Union) - A Fundamental CS Data Structure**

   Two operations, both nearly O(1):
   - **find(x):** Which circuit is element x in?
   - **union(x, y):** Merge circuits containing x and y

   ```swift
   class UnionFind {
       private var parent: [Int]  // parent[i] = parent of element i
       private var size: [Int]    // size[i] = circuit size rooted at i

       func find(_ element: Int) -> Int {
           if parent[element] != element {
               parent[element] = find(parent[element])  // Path compression
           }
           return parent[element]
       }

       func union(_ first: Int, _ second: Int) -> Bool {
           var rootFirst = find(first)
           var rootSecond = find(second)

           if rootFirst == rootSecond { return false }  // Same circuit

           // Union by size: attach smaller to larger
           if size[rootFirst] < size[rootSecond] {
               swap(&rootFirst, &rootSecond)
           }
           parent[rootSecond] = rootFirst
           size[rootFirst] += size[rootSecond]
           return true
       }
   }
   ```

2. **Why Class, Not Struct?**

   `find()` does **path compression** - it mutates `parent` even during a "read":
   ```swift
   parent[element] = find(parent[element])  // ← MUTATION during lookup!
   ```

   This is **shared mutable state** - the classic use case for reference types.

3. **Kruskal's Algorithm (Partial)**

   - Calculate all pairwise distances
   - Sort pairs by distance (shortest first)
   - Process pairs: if different circuits → union; if same → skip
   - Stop after N pairs (Part 1) or when 1 circuit remains (Part 2)

4. **Squared Distance Trick**

   ```swift
   func euclideanDistanceSquared(to other: Point3) -> Int {
       let deltaX = x - other.x
       let deltaY = y - other.y
       let deltaZ = z - other.z
       return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
   }
   ```

   - Avoids `sqrt()` and floating point
   - Same sort order: if √a < √b, then a < b

5. **Comparable Protocol for Clean Sorting**

   ```swift
   struct JunctionPair: Comparable {
       let distance: Int
       let firstIndex: Int
       let secondIndex: Int

       static func < (lhs: JunctionPair, rhs: JunctionPair) -> Bool {
           lhs.distance < rhs.distance
       }
   }

   pairs.sort()  // Just works!
   ```

**When to Use Union-Find**:
- "Are X and Y connected?"
- "Group elements by connectivity"
- "Find connected components"
- "Merge groups incrementally"

**Performance**:
- Part 1: 777ms
- Part 2: 779ms
- Complexity: O(n² log n) for n boxes (~500K pairs for 1000 boxes)

**Swift Techniques**:
- `class` for shared mutable state (path compression mutates during reads)
- `Comparable` protocol for custom sorting
- Nested loops with `(i+1)..<n` for unique pairs
- `Point3` from AoCTools for 3D coordinates

**Answers**:
- Part 1: 54,600 (top 3 circuit sizes: 65 × 30 × 28)
- Part 2: 107,256,172 (X coordinates of final connecting pair)

---

### Day 9: Movie Theater

**The Challenge**: Find the largest rectangle using red tiles as opposite corners. Part 1 allows any rectangle; Part 2 restricts to rectangles within a polygon formed by connecting red tiles.

**Key Insights**:

1. **Inclusive Area Calculation**

   The area formula counts both corner tiles:
   ```swift
   let width = abs(tile2.x - tile1.x) + 1
   let height = abs(tile2.y - tile1.y) + 1
   let area = width * height
   ```

   **Example**: Corners at (2,5) and (11,1)
   - Width = |11-2| + 1 = 10, Height = |5-1| + 1 = 5
   - Area = 50 (not 36!)

2. **Ray Casting for Point-in-Polygon**

   Classic algorithm to determine if a point is inside a polygon:

   ```swift
   func isInsidePolygon(_ point: Point) -> Bool {
       var crossings = 0
       for edge in verticalEdges {
           // Cast ray right, count vertical edge crossings
           if edge.xPos > point.x &&
              edge.yMin <= point.y &&
              point.y < edge.yMax {  // Half-open interval
               crossings += 1
           }
       }
       return crossings % 2 == 1  // Odd = inside
   }
   ```

   **How it works**:
   - Cast a ray from the point horizontally to the right
   - Count how many polygon edges the ray crosses
   - Odd crossings = inside, Even crossings = outside

3. **Polygon Edge Intersection Check**

   Corners being valid isn't enough - must also check no polygon edge pierces the rectangle:

   ```swift
   // Check no vertical edge crosses rectangle interior
   for edge in verticalEdges
   where minX < edge.xPos && edge.xPos < maxX &&
         edge.yMin < maxY && edge.yMax > minY {
       return false  // Edge pierces rectangle!
   }
   ```

   This catches U-shaped polygons where rectangle corners are inside but the rectangle extends outside.

4. **Axis-Aligned Simplification**

   Since all edges are horizontal or vertical:
   - Only check vertical edges for ray casting
   - Simple intersection math (no slopes)
   - Natural decomposition into edge lists

**Complexity**:
- Part 1: O(n²) - check all pairs
- Part 2: O(n³) - check all pairs with O(n) validation each

**Performance**:
- Part 1: ~15ms
- Part 2: ~8.5 seconds (acceptable for puzzle)

**Swift Techniques**:
- Private structs for edge types (avoids large_tuple warning)
- Nested functions for encapsulation
- `for-where` for clean filtering
- Guard with multiple comma-separated conditions

**Pattern Recognition**:

| Problem Type | Algorithm |
|--------------|-----------|
| Point in polygon | Ray casting |
| Polygon area | Shoelace formula |
| Convex hull | Graham scan |
| Rectangle intersection | Separating axis |

**Key Takeaways**:
1. **Inclusive vs exclusive counting** - Read problem carefully!
2. **Ray casting is fundamental** - Know this for polygon problems
3. **Corners valid ≠ rectangle valid** - Check edge intersections too
4. **O(n³) can be acceptable** - Brute force often works for puzzle sizes

**Answers**:
- Part 1: 4,746,238,001
- Part 2: 1,552,139,370

---

### Day 10: Factory (The Hardest Puzzle of 2025!)

**The Challenge**: Part 1 toggles lights (XOR), Part 2 increments counters to reach joltage targets. Part 2 is Integer Linear Programming - the hardest puzzle type we've encountered.

**Key Insights**:

1. **Part 1 is Easy: BFS Over Bitmask States**
   ```swift
   let newState = state ^ buttonMask  // XOR toggle
   ```
   Standard BFS with state as bitmask. XOR is its own inverse.

2. **Part 2 is ILP: Ax = b, minimize sum(x), x >= 0 integer**

   This is NP-hard in general, but tractable for small problems.

3. **Gaussian Elimination Reduces Dimensionality**

   A 10x13 system (10 counters, 13 buttons) reduces to 3 free variables after elimination. This makes exhaustive search practical (~3.4M states).

4. **THE BREAKTHROUGH: Negative Cost Coefficients**

   The "net cost" of increasing a free variable can be NEGATIVE:
   ```swift
   // NetCost = 1 - sum(coefficients in pivot rows)
   // If NetCost < 0: increasing free var DECREASES total!
   ```

   **Why?** When free variable coefficients in the reduced matrix are negative, increasing the free variable causes pivot variables to DECREASE by more than the free variable increases.

   **Implication**: Optimal solutions lie at the "far edge" of the feasible region, NOT near zero!

5. **Search Direction Matters**
   ```swift
   let order = netCost < 0
       ? Array(range.reversed())  // High to low
       : Array(range)             // Low to high
   ```

6. **Rational Arithmetic for Exactness**

   Floating point precision errors caused incorrect -1 results. Use `(numerator, denominator)` tuples with GCD reduction.

**What Failed (And Why)**:

| Attempt | Result | Why It Failed |
|---------|--------|---------------|
| BFS over counter states | Too slow | State space explosion for large targets |
| Floating point Gaussian | Wrong answers | Precision errors |
| Independent bounds computation | Missing solutions | Coupled constraints form polytope, not box |
| Searching from 0 upward | Slow/wrong | Optimal at far edge for negative-cost vars |

**The Winning Algorithm**:
1. Gaussian elimination with rational arithmetic
2. Identify free variables (columns without pivots)
3. Calculate net cost for each free variable
4. Sort by net cost (most negative first)
5. Grid search with smart ordering and aggressive pruning

**Collaboration Win**: Solved with help from Gemini, who identified the negative cost coefficient insight!

**Performance**:
- Part 1: ~13ms (BFS)
- Part 2: ~15 seconds (ILP with search)

**Mathematical Concepts**:
- Linear Algebra (Gaussian elimination, RREF)
- Rational Arithmetic (exact computation)
- Integer Programming (ILP)
- Optimization (minimizing over feasible polytope)

**Wrong Submissions**:
- 13119 (too low) - 16+ machines returning -1
- 14332 (too low) - 9 machines returning -1

**Answers**:
- Part 1: 409
- Part 2: 15489

---

## Preparation and Strategy

### Patterns to Master

Based on AoC 2024 learnings, focus on:

1. **Graph Algorithms**
   - BFS/DFS (shortest paths, exploration)
   - Cycle detection
   - Topological sorting

2. **Dynamic Programming**
   - Memoization
   - State optimization

3. **Simulation**
   - Virtual machines
   - Grid-based movement
   - State machines

4. **Parsing**
   - Custom parsers with swift-parsing
   - Handling various input formats

5. **Math**
   - Linear algebra
   - Number theory
   - Coordinate geometry

6. **Reverse Engineering**
   - Working backwards from desired output
   - Pattern detection
   - Constraint solving

### Swift Skills to Sharpen

- [x] Collections package (Deque, Heap, etc.)
- [x] Bit manipulation
- [x] Functional patterns (reduce, zip, map, filter)
- [x] Generic programming
- [x] Performance optimization techniques

### Problem-Solving Framework

**The "Chug...Chug...Ding!" Approach**:

1. **Understand the goal**: What's the desired outcome?
2. **Gather context**: What constraints and rules apply?
3. **Execute autonomously**: Handle obstacles independently
4. **Deliver working solution**: Validated and tested

**Applied to AoC**:
1. Read problem carefully, identify the question
2. Analyze examples to understand mechanics
3. Implement solution systematically
4. Test with examples, then run actual input
5. Debug systematically when issues arise

### Tools Arsenal

**Development**:
- VSCode with Swift extension (fast iteration)
- Command-line tools (`./run`, `./test`, `./input.sh`)
- Debugger with breakpoints

**Swift Packages**:
- AoCTools (provided utilities)
- swift-parsing (parsing DSL)
- Collections (Deque, etc.)

**Debugging**:
- Start with examples
- Print intermediate states
- Use debugger strategically
- Systematic hypothesis testing

---

## Notes for 2025

### What Worked Well in 2024

✅ **Systematic approach**: Example tests caught bugs early
✅ **VSCode setup**: Fast iteration with `./test` command
✅ **Learning docs**: Day-specific learnings capture insights
✅ **Deque usage**: Proper data structure choice matters
✅ **Working backwards**: Don't always go forward!

### What to Remember

⚠️ **Start simple**: Get part 1 working before optimizing
⚠️ **Test boundaries**: Off-by-one errors are common
⚠️ **Read carefully**: The devil is in the details
⚠️ **Performance matters**: But correctness first
⚠️ **Document insights**: Future you will thank you

### For "Twelve Days of Code 2025"

**Preparation Checklist**:
- [x] Review all AoC 2024 solutions
- [x] Practice BFS/DFS variations
- [x] Master Collections package
- [x] Build template repository
- [x] Refresh on common algorithms
- [x] Set up efficient development environment
- [x] Have debugging playbook ready

**Time Management**:
- Use `./test <day>` for fast iteration
- Don't over-optimize part 1
- Capture learnings as you go
- Take breaks when stuck

---

## Resources

- [Advent of Code 2025](https://adventofcode.com/2025)
- [Swift Collections](https://github.com/apple/swift-collections)
- [swift-parsing](https://github.com/pointfreeco/swift-parsing)
- [AoCTools](https://github.com/gereons/AoCTools)

---

## To Be Updated

This document will grow as more days are completed. Sections to expand:

- [ ] Algorithm patterns as they appear
- [ ] Common pitfalls catalog
- [ ] Performance optimization techniques
- [ ] Grid manipulation patterns
- [ ] String/sequence processing tricks
- [ ] Math formula collection

---

*Document started: December 1, 2025*
*Last updated: December 14, 2025*
*Days completed: 10 / 12 (20 stars)*
*Next up: Day 11! 🎄*
