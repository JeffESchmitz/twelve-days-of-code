# Twelve Days of Code 2025 - Learnings & Insights

> **Purpose**: Document techniques, patterns, and insights from Twelve Days of Code 2025 🎄
>
> Building on the framework and learnings from AoC 2024

**Last Updated**: December 3, 2025
**Progress**: Days 1-12 (3 solved so far, 6 stars)

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
| 4 | TBD | TBD | ⭐ TBD |
| 5 | TBD | TBD | ⭐ TBD |
| 6 | TBD | TBD | ⭐ TBD |
| 7 | TBD | TBD | ⭐ TBD |
| 8 | TBD | TBD | ⭐ TBD |
| 9 | TBD | TBD | ⭐ TBD |
| 10 | TBD | TBD | ⭐ TBD |
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
*Last updated: December 3, 2025*
*Days completed: 2 / 12 (4 stars)*
*Next up: Day 3! 🎄*
