# Advent of Code 2024 - Learnings & Insights

> **Purpose**: Document techniques, patterns, and insights from AoC 2024 to prepare for "Twelve Days of Code" 2025 🎄

**Last Updated**: November 21, 2024
**Progress**: Days 1-23 complete (23 solved! 🎉)

---

## Table of Contents
- [Quick Reference: Days 1-17](#quick-reference-days-1-17)
- [Development Environment](#development-environment)
- [Common Patterns & Algorithms](#common-patterns--algorithms)
- [Swift Toolbox](#swift-toolbox)
- [Debugging Strategies](#debugging-strategies)
- [Problem-Solving Framework](#problem-solving-framework-breaking-down-word-problems)
- [Deep Dives](#deep-dives)
- [Preparation for 2025](#preparation-for-2025)

---

## Quick Reference: Days 1-23

| Day | Title | Key Technique | Complexity |
|-----|-------|---------------|------------|
| 1 | Historian Hysteria | Sorting, zip, reduce | ⭐ Easy |
| 2 | Red-Nosed Reactor | Array validation, enumeration | ⭐ Easy |
| 3 | TBD | Parsing, regex patterns | ⭐⭐ Medium |
| 4 | TBD | Grid search, pattern matching | ⭐⭐ Medium |
| 5 | TBD | Dependency ordering, topological sort | ⭐⭐ Medium |
| 6 | TBD | Path simulation, cycle detection | ⭐⭐⭐ Hard |
| 7 | TBD | Expression evaluation | ⭐⭐ Medium |
| 8 | TBD | Coordinate math, antenna placement | ⭐⭐ Medium |
| 9 | TBD | File system simulation | ⭐⭐⭐ Hard |
| 10 | TBD | Pathfinding, trail navigation | ⭐⭐ Medium |
| 11 | TBD | Number transformation, memoization | ⭐⭐⭐ Hard |
| 12 | TBD | Area/perimeter calculation | ⭐⭐ Medium |
| 13 | TBD | Linear algebra, button presses | ⭐⭐⭐ Hard |
| 14 | TBD | Robot simulation, pattern detection | ⭐⭐⭐ Hard |
| 15 | TBD | Box pushing, state management | ⭐⭐⭐ Hard |
| 16 | TBD | Maze solving, weighted paths | ⭐⭐⭐ Hard |
| **17** | **Chronospatial Computer** | **VM implementation, reverse BFS** | **⭐⭐⭐⭐ Very Hard** |
| **18** | **RAM Run** | **BFS pathfinding, binary search** | **⭐⭐⭐ Hard** |
| **19** | **Linen Layout** | **Memoization (Boolean & Counting)** | **⭐⭐ Medium** |
| **20** | **Race Condition** | **Manhattan distance, enumeration** | **⭐⭐⭐ Hard** |
| **21** | **Keypad Conundrum** | **Multi-layer simulation, path optimization** | **⭐⭐⭐⭐ Very Hard** |
| **22** | **Monkey Market** | **Sequence tracking, dictionary aggregation** | **⭐⭐⭐ Hard** |
| **23** | **LAN Party** | **Graph theory, triangle detection, common neighbors** | **⭐⭐⭐ Hard** |

---

## Development Environment

### VSCode Setup (Completed Nov 8, 2024)

**What We Built:**
- Complete Swift development environment in VSCode
- Debug configurations with breakpoints
- Fast testing workflow (`./test <day>` for incremental compilation)
- Testing UI vs command-line trade-offs

**Key Files:**
- `.vscode/launch.json` - Debug configurations
- `.vscode/tasks.json` - Build and test tasks
- `.vscode/settings.json` - Swift extension config with Xcode 26.1
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

**Day 17 Example** (Reverse Engineering):
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
**Day 17 Insight**: When output depends on input consumption (like dividing by 8), work backwards:
1. Start with values that produce the final output
2. Extend by trying all possible inputs that could lead there
3. BFS naturally finds minimum solutions

### Virtual Machine Implementation

**Day 17 Pattern**:
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
// Day 1: Compare two sorted lists
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

**Day 17 Pattern** - Building values 3 bits at a time:
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

### The Systematic Approach (Used in Day 17)

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

**Example (Day 18)**: "What is the minimum number of steps needed to reach the exit?"
- Output: A single integer (number of steps)
- This word "minimum" hints at: BFS, Dijkstra, or dynamic programming

#### Step 2: Understand the WORLD
**Question**: What's the environment/space we're working in?

**Example (Day 18)**:
- 2D grid: 71×71 (coordinates 0-70)
- Start point: (0,0)
- End point: (70,70)
- Visual representation helps: Draw the grid mentally or on paper

#### Step 3: Identify the CONSTRAINTS
**Question**: What are the rules? What's NOT allowed?

**Example (Day 18)**:
- Movement: Only 4 directions (no diagonals!)
- Boundaries: Must stay within 0-70 in both dimensions
- Obstacles: Cannot enter corrupted coordinates
- Timing: Use FIRST 1024 bytes only (not all input!)

⚠️ **Critical**: Read for "only", "first", "at most", "exactly" - these are constraint boundaries

#### Step 4: Understand the INPUT
**Question**: How is data provided? What format? What order?

**Example (Day 18)**:
- Format: "X,Y" (not "Y,X" - order matters!)
- One coordinate per line
- In chronological order (byte 1, byte 2, ...)
- Must parse carefully - wrong order means wrong answer

#### Step 5: Trace the EXAMPLE
**Question**: Can we manually walk through a small example?

**Example (Day 18)**:
- Smaller grid: 7×7 (not 71×71)
- First 12 bytes (not 1024)
- Expected answer: 22 steps
- Purpose: Validates our understanding before implementing

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

**Example (Day 18)**: Shortest path in unweighted grid → **BFS**

#### Step 7: Identify EDGE CASES and GOTCHAS
**Question**: What could go wrong? What's easy to get wrong?

**Common gotchas**:
- Coordinate system confusion (x,y vs row,col)
- Off-by-one errors (0-70 means 71 elements!)
- Order sensitivity (is sequence important?)
- Impossible states (what if no solution exists?)
- Input parsing mistakes (extra whitespace, wrong separator)

**Example (Day 18)**:
- X,Y order matters
- Grid is 71×71, not 70×70
- First 1024 bytes specifically (not "up to 1024")
- What if path becomes impossible? (hints at Part 2)

#### Step 8: Plan the DATA STRUCTURES
**Question**: What data structures best represent this problem?

**For Day 18**:
- **Corrupted locations**: `Set<Point>` (O(1) lookups)
- **BFS queue**: `Deque<(Point, Int)>` (O(1) append and popFirst)
- **Visited tracking**: `Set<Point>` (O(1) membership test)
- **Input**: `[Point]` or parsed array (ordered matters)

See "Data Structure Selection Criteria" section below.

### The Three-Phase Architecture Pattern 🏗️

**Discovered in Day 21 - A Holistic Problem-Solving Approach**

After completing Day 21 (Keypad Conundrum), a powerful pattern emerged for approaching complex AoC problems. This is a **meta-pattern** that appears across multiple problems and elegantly handles complexity scaling.

#### The Three Phases Explained

**Phase 1: Precompute (One-Time Setup)**
- Do expensive work ONCE, then reuse it forever
- Example (Day 21): BFS all button pairs on both keypads, store all results
- Result: "I know how to get from any button to any other button"
- Time investment: Usually small, but pays dividends

**Phase 2: Optimize for Current Problem**
- With precomputed knowledge, solve the specific problem optimally
- Example (Day 21): Given code "029A", find the BEST numeric keypad sequence
- Not just "a" shortest path, but THE optimal one considering downstream costs
- Uses Phase 1 data to make smart, informed choices

**Phase 3: Calculate Final Answer (Leverage Everything)**
- Recursively apply optimization through all layers/iterations
- Example (Day 21): Calculate what YOU have to type given the optimal numeric sequence
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

#### Where This Pattern Appears

| Day | Phase 1 | Phase 2 | Phase 3 |
|-----|---------|---------|---------|
| **18** | Precompute BFS distances | Binary search on byte count | Return blocking byte |
| **17** | Implement VM instruction set | Reverse engineer output requirements | BFS backward to find answer |
| **11** | Precompute number transformations | Apply to specific case | Memoize across depth levels |
| **21** | Precompute button-to-button paths | Select optimal paths | Recursively calculate length |

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

#### Example: Day 21 in Three Phases

```swift
// Phase 1: Precompute (one-time)
let numericPaths = computeNumericPaths()      // BFS on all buttons
let directionalPaths = computeDirectionalPaths() // BFS on all buttons

// Phase 2: Optimize (per code)
for code in codes {
    let numericSeq = findNumericSequence(code, ...)  // Pick optimal path

    // Phase 3: Calculate (leveraging memoization)
    let finalLength = sequenceLength(numericSeq, depth: 2, ...)  // Recursive + cached
}
```

For Part 2, Phase 1 & 2 stay identical. Only Phase 3 parameter changes:
```swift
let finalLength = sequenceLength(numericSeq, depth: 25, ...)  // Same code!
```

---

### Key Information Extraction Checklist

Use this checklist when reading any AoC problem:

✅ **Goal**: What's the final answer we need? (number, coordinate, string, etc.)
✅ **World**: What space/environment? (grid, graph, list, etc.)
✅ **Start/End**: Where do we begin? Where do we finish?
✅ **Rules**: How can we move/act? What transitions are allowed?
✅ **Obstacles**: What blocks us or prevents certain actions?
✅ **Input format**: How is data provided? (lines, grid, comma-separated, etc.)
✅ **Critical numbers**: Any magic numbers? (1024, 50, etc.) Are they exact or approximate?
✅ **Example**: Can we trace through the example? Do we get expected answer?
✅ **Algorithm**: What CS pattern fits this problem?
✅ **Edge cases**: What could break our solution? (empty input, no solution, boundary conditions)

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
| "minimum path", "shortest" | BFS, Dijkstra | Day 18 |
| "first X that", "blocks path" | Binary search (monotonic) | Day 18 |
| "all ways", "count paths" | DP, DFS | Days 5, 11 |
| "optimize/maximize" | DP, Greedy | Day 13 |
| "ordered by dependencies" | Topological sort | Day 5 |
| "simulate forwards" | Simulation | Days 6, 14 |
| "find reverse input" | BFS backwards | Day 17 |
| "area/perimeter" | Flood fill, graph traversal | Day 12 |

---

### 🌟 Composite Algorithm Patterns: BFS + Binary Search

One of the most elegant patterns discovered in AoC 2024 is the **composition of two algorithms** to solve two-part problems efficiently.

#### The Pattern

**Part 1**: Solve with a base algorithm (e.g., BFS for pathfinding)
**Part 2**: If monotonic property exists, use binary search to call Part 1's algorithm O(log n) times instead of O(n)

#### Day 18: The Perfect Example

**Part 1 - BFS Pathfinding**:
- Find shortest path through corrupted memory grid
- Answer: 250 steps
- Time: ~5ms

**Part 2 - Binary Search for Blocking Byte**:
- Find FIRST byte that blocks all paths
- Key insight: Once path is blocked, it stays blocked (monotonic!)
- Naive approach: Linear search = O(n) × O(grid²) = ~17 seconds
- Smart approach: Binary search = O(log n) × O(grid²) = ~60ms
- **Speedup: 280x faster!**

#### Why This Works

```
After N bytes: Path exists ✅
After N+1 bytes: If blocked, STAYS blocked ❌ (monotonic property!)
After N+2 bytes: Still blocked ❌
```

Once a cell becomes corrupted, it never heals. This irreversible property enables binary search.

#### The Code Elegance

```swift
// Part 1: Core algorithm
func findShortestPath(gridSize: Int, byteCount: Int) -> Int {
    // BFS implementation
    return steps  // or -1 if no path
}

// Part 1 wrapper
func part1() async -> Int {
    findShortestPath(gridSize: 70, byteCount: 1024)
}

// Part 2: Binary search calls Part 1 repeatedly
func part2() async -> Int {
    var left = 0
    var right = coordinates.count - 1

    while left < right {
        let mid = (left + right) / 2
        if findShortestPath(gridSize: 70, byteCount: mid + 1) >= 0 {
            left = mid + 1  // Path exists, blocker is later
        } else {
            right = mid     // Path blocked, blocker is at or before mid
        }
    }

    return coordinates[left]
}
```

#### Key Insight: Code Reusability

By writing Part 1 **cleanly and configurably**, Part 2 becomes trivial:
- Same BFS algorithm
- Same data structures (Set<Point>, Deque)
- Just called with different parameters
- Part 1 code is tested directly from Part 2

#### When to Look for This Pattern

1. **Part 1**: Solves a problem with clear algorithm
2. **Part 2**: Asks for "first X that" or "when does Y happen?"
3. **Monotonic property**: Once a condition is true/false, it stays that way
4. **Constraint**: Parameters vary between example and real input

#### Expected AoC Patterns Using This

This composite pattern likely appears in future AoC years:
- Finding first time a threshold is exceeded
- Binary searching for optimal values
- Finding transition points in ordered sequences
- Efficiency problems where naive O(n²) becomes O(n log n)

---

### Applied Example: Day 18 (Part 1 & Part 2)

#### Part 1: Shortest Path

Let's apply this framework to Day 18 Part 1:

**1. Goal**: Minimum steps from (0,0) to (70,70) → **Number output**

**2. World**: 71×71 grid

**3. Constraints**:
- 4-directional movement
- Stay in bounds
- Avoid corrupted cells
- Use first 1024 bytes

**4. Input**: "X,Y" coordinates, one per line

**5. Example**: 7×7 grid, 12 bytes → 22 steps

**6. Algorithm**: "Minimum" + "path" + "grid" → **BFS**

**7. Edge Cases**:
- Path might become impossible (Part 2 hint!)
- Grid size is configurable
- Order of bytes matters

**8. Data Structures**:
- `Set<Point>` for corrupted locations (O(1) lookup)
- `Deque<(Point, Int)>` for BFS queue (O(1) operations)
- `Set<Point>` for visited tracking (O(1) membership test)

**Result**: 250 steps | Performance: ~6ms

#### Part 2: Binary Search for Blocking Byte

What appeared to be Part 2 required a completely different algorithm:

**Key Insight**: "Find the **first** byte that prevents the exit from being reachable"

**Problem Decomposition** (using our framework):
1. **Goal**: Coordinates of blocking byte (X,Y format)
2. **World**: Same 71×71 grid, but now processing ALL bytes
3. **Critical Property**: Once path is blocked, it stays blocked (monotonic!)
4. **Algorithm**: "First X that" + "monotonic property" → **Binary Search**

**Why Binary Search?**
- **Linear approach**: Try each byte sequentially = O(n²) = 17 seconds
- **Binary search**: Find blocking point with log₂(n) iterations = O(n log n) = 60ms
- **Speedup**: 280x faster!

**The monotonic property** is the KEY insight that enables binary search:
```
After N bytes: Path exists ✅
After N+1 bytes: If blocked, STAYS blocked ❌
After N+2, N+3... bytes: Still blocked ❌
```

**Result**: First blocking byte is (56,8) | Performance: ~13ms | Speedup: 280x!

This demonstrates the power of problem decomposition:
1. Solve Part 1 cleanly (BFS with configurable parameters)
2. Recognize Part 2's hidden structure (monotonic property)
3. Apply appropriate algorithm (binary search)
4. Reuse Part 1's code (called O(log n) times instead of trying all possibilities)

---

### Practice Tips

1. **Always trace the example** - Even if it takes 10 minutes, it prevents implementation errors
2. **Write down the critical numbers** - Highlight "1024", "70", "7×7" so you don't mix them up
3. **Question your assumptions** - If something feels off, re-read the problem
4. **Identify the "gotcha"** - Most problems have one trick that catches people
5. **Algorithm first, code second** - Know your approach before you start typing



### Day 17: Chronospatial Computer ⭐⭐⭐⭐

**The Challenge**: Build a 3-bit VM, then reverse-engineer it to find input that makes it output itself (quine)

**Part 1 - VM Implementation**:
- 8 opcodes (adv, bxl, bst, jnz, bxc, out, bdv, cdv)
- Combo operands vs literal operands
- Instruction pointer management with jumps

**Key Bugs Fixed**:
1. Index bounds: `while ip < program.count - 1` (need space for operand)
2. Jump double-increment: Don't increment IP in jnz if jumping
3. Input parsing: `split()` skips empty lines (program at index 3, not 4)

**Part 2 - Reverse Engineering**:
- **Insight**: Each iteration divides A by 8 (consumes 3 bits)
- **Approach**: Work backwards from desired output
- **Algorithm**: BFS with Deque, building A 3 bits at a time
- **Performance**: ~7ms (way faster than brute force!)

**The "Aha!" Moment**:
```swift
// Don't try all possible A values forward
// Build A backwards by trying 3-bit extensions
for outputIndex in (0..<target.count).reversed() {
    for bits in 0..<8 {
        let candidateA = (currentA << 3) | bits
        // Test if this produces the right suffix
    }
}
```

**See**: `Sources/Day17/Day17-learnings.md` for full details

**Performance**:
- Part 1: ~0.1ms
- Part 2: ~7ms

---

### Day 18: RAM Run ⭐⭐⭐

**The Challenge**: Navigate a corrupted memory grid with BFS, then use binary search to find when the path gets blocked

**Part 1 - BFS Pathfinding**:
- Find shortest path from (0,0) to (70,70) avoiding corrupted cells
- Answer: 250 steps
- Performance: ~5ms

**Key Insight - Monotonic Property**:
Once path is blocked by corrupted bytes, it stays blocked. This enables binary search!

**Part 2 - Binary Search for Blocking Byte**:
- Linear approach: O(n²) = 17 seconds ❌
- Binary search: O(n log n) = 60ms ✅
- **Speedup: 280x!**

**Why This Worked**:
- Part 1 written cleanly with configurable parameters
- Part 2 reuses Part 1's BFS algorithm
- Same data structures (Set<Point>, Deque)

**See**: `Sources/Day18/Day18-learnings.md` for full details

**Performance**:
- Part 1: ~5ms
- Part 2: ~60ms

---

### Day 19: Linen Layout ⭐⭐

**The Challenge**: Memoization for both feasibility checking and counting

**Part 1 - Can we make it?**:
- Check if each design can be constructed from patterns
- Use memoization to cache `String -> Bool`
- Answer: 371 valid designs

**Part 2 - How many ways?**:
- Count ALL possible ways to construct each design
- Same memoization structure but accumulate instead of return early
- Transform: `Bool` -> `Int`, `return true` -> `total += count(rest)`
- Answer: 692,596,560,138,745

**The Key Transformation**:
```swift
// Part 1: Feasibility
if remaining.isEmpty { return true }
if canMake(rest) { return true }

// Part 2: Counting
if remaining.isEmpty { return 1 }
total += count(rest)  // Try ALL patterns
```

**Performance Impact**:
- Without memoization: 2^(design length) = exponential ❌
- With memoization: O(n² × m) = ~200ms ✅
- **Speedup: 1000x+!**

**See**: `Sources/Day19/Day19-learnings.md` for full details

**Performance**:
- Part 1: ~30ms
- Part 2: ~210ms

---

### Day 20: Race Condition ⭐⭐⭐

**The Challenge**: Grid-based pathfinding with "cheating" mechanic (bypass walls for time savings)

**Solutions**:
- Part 1 (max 2-step cheat): **1323** cheats save ≥100 picoseconds
- Part 2 (max 20-step cheat): **983,905** cheats save ≥100 picoseconds

**Key Insights**:
1. **Single Path**: There's only ONE path from S to E (no branching!)
2. **BFS Distance Mapping**: Pre-compute distances to ALL track positions
3. **Manhattan Distance**: Cheat distance = Manhattan distance between endpoints
4. **Elegant Parametric Design**: Same algorithm for both parts, just different `maxCheatDistance`

**Algorithm: BFS + Manhattan Distance Enumeration**:

```swift
func findCheatsWithThreshold(maxCheatDistance: Int, threshold: Int) -> Int {
    // 1. BFS to map distances from start to all track positions
    let (distances, path) = bfsWithPath()

    // 2. For each path position, enumerate nearby positions
    for position in path {
        for dx in -maxCheatDistance...maxCheatDistance {
            for dy in -maxCheatDistance...maxCheatDistance {
                let manhattanDist = abs(dx) + abs(dy)
                guard 0 < manhattanDist <= maxCheatDistance else { continue }

                let cheatEnd = Point(position.x + dx, position.y + dy)
                guard let endDist = distances[cheatEnd], endDist > distances[position]! else { continue }

                // Time saved = normal path length - cheat length
                let timeSaved = (endDist - distances[position]!) - manhattanDist
                if timeSaved >= threshold {
                    validCheatCount += 1
                }
            }
        }
    }
    return validCheatCount
}
```

**Part 1 vs Part 2**:
```swift
func part1() { findCheatsWithThreshold(maxCheatDistance: 2, threshold: 100) }
func part2() { findCheatsWithThreshold(maxCheatDistance: 20, threshold: 100) }
```

**Why This Works**:
- **Single path property**: BFS finds THE unique path in one pass
- **Pre-computed distances**: O(1) cheat evaluation (no re-BFSing)
- **Enumeration with bounds**: Only check ~12 neighbors (Part 1) or ~400 (Part 2)
- **Natural deduplication**: Forward-progress filter prevents counting same (start, end) twice

**Complexity Analysis**:

| Metric | Part 1 | Part 2 |
|--------|--------|--------|
| maxCheatDistance | 2 | 20 |
| Neighbors/position | ~8 | ~400 |
| Time | 33ms | 964ms |

- BFS: O(W × H)
- Enumeration: O(path_length × C²) where C = maxCheatDistance
- Total: O(W×H) + O(P×C²)

**Data Structures**:
- `Deque<Point>`: BFS queue (O(1) popFirst, append)
- `Set<Point>`: Visited tracking (O(1) operations)
- `[Point: Int]`: Distance mapping (O(1) lookup)
- `[Point]`: Path reconstruction (for ordered iteration)

**Key Design Decision**:
Store `gridPoints: [Point: Character]` (not `grid: Grid<Character>`) to be Sendable-compatible for async functions.

**See**: `Sources/Day20/Day20-learnings.md` for complete implementation details

**Performance**:
- Part 1: 33ms
- Part 2: 964ms
- Total: ~1 second for both parts ✅

---

### Day 21: Keypad Conundrum ⭐⭐⭐⭐

**The Challenge**: Multi-layer keypad simulation with path optimization for nested robot sequences.

**Key Insights**:
1. **Gap Avoidance**: Both numeric and directional keypads have gaps that robots can't traverse
2. **Multiple Shortest Paths**: When multiple paths tie for length, downstream costs differ
3. **Three-Phase Architecture**:
   - Phase 1: Precompute all button-to-button paths via BFS
   - Phase 2: Select optimal numeric sequence considering downstream costs
   - Phase 3: Recursively calculate final input length with memoization

**The Critical Discovery**: Path selection matters! Two paths may have equal length, but when fed through nested robot layers, one expands more than the other. Must try all shortest paths and pick minimum downstream cost.

**Results**:
- Part 1 (depth 2): **242,484**
- Part 2 (depth 25): **294,631,556,874,548**

**Data Structures**:
- `[Character: [Character: [String]]]` for precomputed paths
- `[String: Int]` for memoization cache (keyed by "sequence:depth")
- `Set<Point>` for position validation and gap detection

**Why This Pattern Matters**: The three-phase approach (precompute, optimize, scale) appears across multiple AoC problems. When Part 2 requires massive scaling (2 → 25 layers), clean architecture enables simple parameter changes rather than rewrites.

**Performance**:
- Part 1: ~1.1ms
- Part 2: ~1.2ms (exponential numbers, but memoization is key!)

**See**: `Sources/Day21/Day21-learnings.md` for complete implementation details

---

### Day 22: Monkey Market ⭐⭐⭐

**The Challenge**: Secret number generation with sequence-based price trading optimization.

**Part 1 - Pseudorandom Number Generation**:
- Generate 2000 secret numbers using XOR-based transformation
- Three operations per iteration: multiply (×64), divide (÷32), multiply (×2048)
- Each operation: mix (XOR with original), prune (mod 16,777,216)
- Answer: Sum of 2000th secret number from each buyer

**Part 2 - Sequence Matching for Maximum Profit**:
- Extract ones digits from secret numbers → prices
- Track price changes (difference between consecutive prices)
- Find 4-change sequence that maximizes total bananas across all buyers
- Key constraint: Only the FIRST occurrence per buyer counts

**Algorithm Strategy**:
- Pre-compute all sequences that actually appear (not all 19^4 possibilities!)
- Dictionary with String keys mapping sequences to prices
- Per-buyer deduplication ensures first occurrence only
- Linear scan for maximum sum

**Data Structures**:
- `[String: [Int]]` for sequence → prices mapping
- `Set<String>` for per-buyer "seen sequences"
- Array for prices and changes

**Key Pattern**: Pre-computation approach is significantly faster than brute force:
- Brute force: Try all 130,321 sequences × all buyers
- Smart approach: Only process sequences that actually appear
- Part 2 result: **2,218** bananas

**Results**:
- Part 1: **18,941,802,053**
- Part 2: **2,218**

**Performance**:
- Part 1: ~5ms
- Part 2: ~4.5 seconds (2,247 buyers × 1,996 sequence windows)

**Key Learnings**:
1. Pre-computation beats brute force when most combinations don't exist
2. String keys work well for composite data when tuples aren't hashable
3. Per-buyer tracking prevents duplicate counting
4. Dictionary aggregation is powerful for finding maximum over groups

**See**: `Sources/Day22/Day22-learnings.md` for complete implementation details

---

### Day 23: LAN Party ⭐⭐⭐

**The Challenge**: Find all connected triangles (3-cliques) in a computer network graph, then discover the largest clique where every computer connects to every other computer.

**Part 1 - Triangle Detection**:
- Find all sets of three computers where each connects to the other two
- Filter to count only triangles with at least one computer starting with 't'
- Result: **1,108 triangles**
- Performance: ~0.18ms

**Part 2 - Maximum Clique Discovery**:
- Find the largest clique (complete subgraph) in the network
- Return alphabetically sorted computer names as password
- Result: **13-node clique** (ab,cp,ep,fj,fl,ij,in,ng,pl,qr,rx,va,vf)
- Performance: ~24 seconds

**Algorithm Strategy**:

*Part 1 - The "Common Neighbors" Insight*:
Instead of checking all possible triplets (O(V³)), exploit the graph structure:
- For each edge (A-B), find common neighbors: nodes connected to BOTH A and B
- Each common neighbor C forms a triangle (A-B-C)
- Deduplication via sorted string representation in a Set

```swift
// Core pattern: intersection for common neighbors
let common = neighborsA.intersection(neighborsB)  // O(1) with Set
for nodeC in common {
    // (nodeA, nodeB, nodeC) forms a triangle!
}
```

*Part 2 - Greedy Clique Expansion*:
- Start with all 3-cliques from Part 1 (guaranteed valid starting points)
- For each triangle, greedily expand by adding nodes connected to ALL current members
- The key validation pattern:
  ```swift
  candidates.filter { candidate in
      cliqueArray.allSatisfy { cliqueNode in
          (adjacencyList[cliqueNode] ?? []).contains(candidate)
      }
  }
  ```
- This nested closure is the "magic": for each candidate, check ALL clique members

**Key Insights**:
1. **Follow connections, not combinations**: Instead of checking all possible groups, follow the graph's existing connections
2. **Data structure matters**: Using `Set` instead of `Array` for neighbors changes complexity from O(V × d³) to O(V × d²)
3. **Greedy beats optimal here**: Full Bron-Kerbosch algorithm is theoretically correct but slow. Greedy expansion from triangles is practical for bounded clique sizes
4. **Deduplication through normalization**: Sort nodes before storing to avoid expensive duplicate checking later

**Complexity Analysis**:
- Part 1: O(E × d) where E = edges, d = average degree
  - Operations: ~44,000 (3,389 edges × 13 average degree)
  - Compare to brute force: O(V³) = 140+ million operations
  - **Speed gain: ~3,000x faster**
- Part 2: O(T × V × D) where T = triangles, V = vertices, D = max degree
  - Greedy expansion from ~1,100 triangles is practical

**Data Structures**:
- `[String: Set<String>]` for adjacency list (O(1) neighbor lookup)
- `Set<String>` for triangles and candidates (O(1) deduplication)
- Set intersection for finding common neighbors

**Real-World Applications**:
This "common friend" pattern appears everywhere:
- Social networks: "You have mutual friends"
- Recommendation engines: "You both watched this movie"
- Fraud detection: "These accounts are all connected"
- Network topology: "This group is tightly interconnected"
- Collaborative filtering: "Similar users liked similar items"

**Results**:
- Part 1 Example: **7** triangles
- Part 1 Solution: **1,108** triangles
- Part 2 Example: **co,de,ka,ta** (4-node clique)
- Part 2 Solution: **ab,cp,ep,fj,fl,ij,in,ng,pl,qr,rx,va,vf** (13-node clique)

**See**: `Sources/Day23/Day23-learnings.md` for complete deep dive with graph theory fundamentals, algorithm walkthrough, and Swift-specific patterns.

---

## Preparation for 2025

### Patterns to Master

Based on Days 1-20, focus on:

1. **Graph Algorithms**
   - BFS/DFS (shortest paths, exploration)
   - Cycle detection
   - Topological sorting

2. **Dynamic Programming**
   - Memoization (seen in Day 11)
   - State optimization

3. **Simulation**
   - Virtual machines (Day 17)
   - Grid-based movement (Days 6, 14, 15, 16)
   - State machines

4. **Parsing**
   - Custom parsers with swift-parsing
   - Handling various input formats

5. **Math**
   - Linear algebra (Day 13)
   - Number theory
   - Coordinate geometry

6. **Reverse Engineering**
   - Working backwards from desired output
   - Pattern detection
   - Constraint solving

### Swift Skills to Sharpen

- [ ] Collections package (Deque, Heap, etc.)
- [ ] Bit manipulation
- [ ] Functional patterns (reduce, zip, map, filter)
- [ ] Generic programming
- [ ] Performance optimization techniques

### Problem-Solving Framework

**The "Chug...Chug...Ding!" Approach** (From Jeff's profile):

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

## Notes for Next Year

### What Worked Well

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
- [ ] Review all AoC 2024 solutions
- [ ] Practice BFS/DFS variations
- [ ] Master Collections package
- [ ] Build template repository
- [ ] Refresh on common algorithms
- [ ] Set up efficient development environment
- [ ] Have debugging playbook ready

**Time Management**:
- Use `./test <day>` for fast iteration
- Don't over-optimize part 1
- Capture learnings as you go
- Take breaks when stuck

---

## Resources

- [AoC 2024](https://adventofcode.com/2024)
- [Swift Collections](https://github.com/apple/swift-collections)
- [swift-parsing](https://github.com/pointfreeco/swift-parsing)
- [AoCTools](https://github.com/gereons/AoCTools)

---

## To Be Updated

This document will grow as more days are completed. Sections to expand:

- [ ] More algorithm patterns (dynamic programming, greedy, etc.)
- [ ] Common pitfalls catalog
- [ ] Performance optimization techniques
- [ ] Grid manipulation patterns
- [ ] String/sequence processing tricks
- [ ] Math formula collection

---

*Document started: November 8, 2024*
*Days completed: 23 / 25*
*Ready for: Days 24-25! Final countdown 🎄*
