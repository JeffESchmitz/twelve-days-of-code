# AoC Agent Stack Architecture

> **Purpose**: Design a multi-agent system for solving Advent of Code problems efficiently
>
> **Created**: November 11, 2024
>
> **Status**: Reference architecture for implementation

---

## Overview

The AoC Agent Stack is a hierarchical system of specialized agents that work together to solve coding puzzles systematically. Each agent is optimized for specific tasks in the problem-solving workflow.

```
┌─────────────────────────────────────────────────────────────┐
│                 PROBLEM STATEMENT INPUT                      │
└────────────────────────┬────────────────────────────────────┘
                         │
           ┌─────────────▼──────────────────────┐
           │  PUZZLE TEACHER AGENT (NEW!)       │ ← META-COORDINATOR
           │  (Interactive Learning Guide)      │    Socratic questioning
           │  (Orchestrates all other agents)   │    Pattern teaching
           │  (Validates YOUR understanding)    │    Reinforces learning
           └─────────────┬──────────────────────┘
                         │
           ┌─────────────▼──────────────┐
           │  Problem Analyzer Agent    │ ← KNOWLEDGE COORDINATOR
           │  (8-step decomposition)    │
           └─────────────┬──────────────┘
                         │
        ┌────────┬───────┼────────┬─────────────┐
        │        │       │        │             │
   ┌────▼──┐ ┌──▼───┐ ┌─▼────┐ ┌▼──────┐ ┌────▼──────┐
   │ Goal  │ │World │ │Rules │ │ Input │ │ Gotchas  │
   │Finder │ │Mapper│ │Expert│ │Parser │ │Detective │
   └────┬──┘ └──┬───┘ └─┬────┘ └┬──────┘ └────┬──────┘
        │       │       │       │             │
        └───────┼───────┼───────┼─────────────┘
                │       │       │
        ┌───────▼───────▼───────▼───────┐
        │  Algorithm Selector Agent      │
        │  (Pattern → Algorithm mapping) │
        └───────┬───────────────────────┘
                │
        ┌───────▼────────────────────────┐
        │ Data Structure Advisor Agent    │
        │ (Performance-based selection)   │
        └───────┬────────────────────────┘
                │
        ┌───────▼────────────────────────┐
        │  Specialist Selection Agent     │
        │  (Route to domain expert)       │
        └───────┬────────────────────────┘
                │
    ┌───────────┼───────────┬────────────┬──────────────┐
    │           │           │            │              │
┌───▼──┐ ┌──────▼──┐ ┌──────▼───┐ ┌────▼────┐ ┌───────▼────┐
│Graph │ │  Linear │ │Combinat- │ │ String  │ │   Virtual  │
│Theory│ │ Algebra │ │ orics    │ │Matching │ │  Machine   │
│Expert│ │ Expert  │ │ Expert   │ │ Expert  │ │  Specialist│
└──────┘ └─────────┘ └──────────┘ └─────────┘ └────────────┘
    │           │           │            │              │
    └───────────┼───────────┴────────────┴──────────────┘
                │
        ┌───────▼────────────────────────┐
        │  Implementation Coordinator    │
        │  (Code generation & testing)   │
        └───────┬────────────────────────┘
                │
        ┌───────▼────────────────────────┐
        │  Performance Analyzer Agent    │
        │  (Benchmark & optimize)        │
        └────────────────────────────────┘
```

---

## Agent Specifications

### 0. **Puzzle Teacher Agent** (Meta-Coordinator & Learning Guide)

**Role**: Interactive guide that teaches you HOW to think, not just WHAT to do

**Philosophy**: Learning through Socratic questioning, pattern recognition, and guided discovery

**Inputs**:
- Problem statement from AoC
- Your answers to questions
- Your code (for code review)
- Your understanding gaps

**Outputs**:
- Guided questions that deepen your thinking
- Validation of your understanding
- Pattern connections across problems
- Learning reinforcement and takeaways

**Unique Capabilities**:
```
FIVE TEACHING MODES:

1. DISCOVERY MODE
   - Don't tell you the answer
   - Ask questions that guide you to discover it
   - "Why did you think of BFS?" → teaches you to recognize patterns

2. EXPLORATION MODE
   - Probe your understanding deeply
   - Challenge assumptions
   - "Why NOT DFS for this?" → teaches algorithm selection

3. VALIDATION MODE
   - Check understanding before implementation
   - Catch misunderstandings early
   - "Can you explain why Set over Array?" → teaches data structures

4. DEBUGGING MODE
   - Don't fix bugs directly
   - Ask questions that lead you to find them
   - "When would BFS return -1?" → teaches debugging methodology

5. SYNTHESIS MODE
   - Connect individual problems to patterns
   - Show you recurring structures
   - "Did you see this pattern before?" → teaches meta-learning
```

**When to Invoke**:

**Option A (Fast Mode)**: Use other agents directly
- 30-45 minutes per problem
- Get the answer quickly
- Good for solving puzzles

**Option B (Learning Mode)**: Route through Puzzle Teacher
- 45-90 minutes per problem
- Deep understanding
- Build problem-solving skills
- Connect patterns across problems

**Learning Progression**:
```
Days 1-5:  "Show me the algorithm, I want to solve"
           → Fast Mode (direct agent calls)

Days 6-12: "Teach me to recognize patterns"
           → Hybrid Mode (Learning with guidance)

Days 13+:  "Help me think like a master problem-solver"
           → Puzzle Teacher Mode (Socratic questions)
```

**Prompting Strategy**:
```
USE THIS to invoke Puzzle Teacher mode:

"I want to LEARN how to solve this problem, not just get the answer.

Use Puzzle Teacher mode:
1. Ask me questions about the problem
2. Guide me through the 8-step breakdown
3. Have me EXPLAIN my thinking
4. Point out patterns I should remember
5. Validate my understanding before I code

[PASTE PROBLEM]

Let's start: What do you notice about this problem?"
```

**Key Differentiator from Other Agents**:
- Problem Analyzer: "Here's the decomposition"
- Puzzle Teacher: "What's YOUR decomposition? Let me ask you questions..."
- Algorithm Selector: "This algorithm fits"
- Puzzle Teacher: "Why do you think this algorithm fits? Can you explain it?"

**Expected Impact**:
- ✅ Understand patterns, not just memorize solutions
- ✅ Recognize similar problems across years
- ✅ Develop transferable problem-solving skills
- ✅ Catch your own bugs faster
- ✅ Build confidence in unfamiliar problem types
- ✅ Transform from "puzzle solver" to "problem analyst"

**See**: `AOC-PUZZLE-TEACHER.md` for complete teaching modes and prompts

---

### 1. **Problem Analyzer Agent** (Knowledge Coordinator)

**Role**: Orchestrates the entire problem-solving workflow

**Inputs**:
- Raw problem statement from AoC
- Example input and output
- Problem constraints

**Outputs**:
- Structured problem analysis following 8-step framework
- Identified goal, world, constraints, input format, edge cases
- Recommended algorithms and data structures
- Routing instructions to specialist agents

**Prompting Strategy**:
```
You are the Problem Analyzer for Advent of Code puzzles.
Your job is to systematically decompose a problem using the 8-step framework.

Apply these steps:
1. GOAL: What's the final answer we need?
2. WORLD: What's the environment/space?
3. CONSTRAINTS: What are the rules?
4. INPUT: How is data provided?
5. EXAMPLE TRACE: Walk through example manually
6. ALGORITHM PATTERN: What CS technique fits?
7. EDGE CASES: What could go wrong?
8. DATA STRUCTURES: What structures best represent this?

For each step, be explicit and concrete.
End with a summary: "This is a [PATTERN] problem requiring [ALGORITHM]."
```

**When to invoke**: ALWAYS - at the start of every AoC problem

---

### 2. **Algorithm Selector Agent**

**Role**: Maps problem characteristics to algorithmic approaches

**Specialty**: Pattern recognition

**Input Analysis**:
```
Pattern → Algorithm Mapping (from your learnings):

"shortest path" / "minimum steps"          → BFS or Dijkstra
"first X that blocks/enables"              → Binary search (if monotonic)
"count all ways"                           → DP or DFS with memoization
"find if possible"                         → BFS, DFS, or brute force
"simulate forward"                         → Simulation with state tracking
"find reverse input"                       → BFS backwards
"area/perimeter"                           → Flood fill or graph traversal
"ordered by dependencies"                  → Topological sort
"maximize/optimize choosing"                → Greedy or DP
"find pattern in sequence"                 → Mathematical analysis
"divide into equal parts"                  → Modular arithmetic / Number theory
"system of equations"                      → Linear algebra
"count combinations/permutations"          → Combinatorics
```

**Output**:
- Primary algorithm recommendation
- Alternative approaches
- Why this algorithm fits
- Time/space complexity expectations

**When to invoke**: After Problem Analyzer identifies the pattern

---

### 3. **Data Structure Advisor Agent**

**Role**: Recommends data structures based on operation performance

**Decision Framework**:
```
Question: "Will this operation be called frequently?"

If YES:
  - Membership testing → Set (O(1)) not Array (O(n))
  - Queue operations → Deque (O(1)) not Array (O(n))
  - Key-value lookups → Dictionary (O(1)) not Array (O(n))

If NO:
  - Use simple structure (Array)
  - Clarity > raw performance

Question: "What's the dominant operation?"
  - If lookups: Set, Dictionary
  - If appending: Array, Deque
  - If both: Often Set is best despite append cost
  - If ordered: Use sorted Array or Heap
```

**Performance Impact Analysis**:
```
Operation Frequency × Operation Cost = Total Time

Day 18 Example:
- Check if point corrupted: ~100,000 times
- Array.contains: O(n) = catastrophic
- Set.contains: O(1) = fast
- Difference: 5ms vs 2+ seconds (280x!)
```

**When to invoke**: When implementing core algorithms

---

### 4. **Edge Case Hunter Agent**

**Role**: Identifies problem gotchas before implementation

**Patterns to Hunt**:
```
✓ Off-by-one errors (0-70 means 71 elements)
✓ Order sensitivity ("X,Y" not "Y,X")
✓ Exact counts ("first 1024", not "up to 1024")
✓ Missing elements (split() skips empty lines)
✓ Impossible states (no solution exists?)
✓ Boundary conditions (grid corners, start/end)
✓ Type mismatches (problem asks for coordinates, framework wants Int)
✓ Index out of bounds (need both opcode AND operand)
✓ State assumptions (can we modify input? reset state?)
```

**When to invoke**: Before and during implementation

---

### 5. **Specialist Agents** (Domain Experts)

#### **5a. Graph Theory Expert**
**Activated for**: BFS, DFS, pathfinding, cycle detection, connectivity
```
Specializes in:
- Shortest paths (BFS)
- Traversal order (DFS)
- Cycle detection
- Connected components
- Topological sorting
- Graph representation (adjacency list vs matrix)
```

#### **5b. Linear Algebra Expert**
**Activated for**: Systems of equations, matrix operations, button presses
```
Specializes in:
- Gaussian elimination
- Matrix inversion
- Linear system solving
- Coordinate transformations
- Example: Day 13 (button A presses × effect + button B presses × effect = goal)
```

#### **5c. Number Theory Expert**
**Activated for**: Modular arithmetic, cycles, periodicity, prime properties
```
Specializes in:
- GCD / LCM for finding cycles
- Modular arithmetic properties
- Prime factorization
- Detecting periodicity in sequences
```

#### **5d. Combinatorics Expert**
**Activated for**: Counting problems, permutations, combinations
```
Specializes in:
- Counting paths/ways
- Permutations and combinations
- Inclusion-exclusion principle
- Identifying identical solutions (symmetry)
```

#### **5e. String Matching Expert**
**Activated for**: Regex, parsing, pattern matching, substring operations
```
Specializes in:
- Regex patterns and edge cases
- Parsing strategies (swift-parsing)
- Substring matching (hasPrefix, dropFirst)
- String decomposition problems
- Example: Day 19 (pattern matching with memoization)
```

#### **5f. Virtual Machine / Simulation Expert**
**Activated for**: CPU simulation, state machines, complex simulations
```
Specializes in:
- Instruction dispatch
- State management
- Instruction pointer handling
- Register operations
- Common bugs (double-increment, bounds checking)
- Example: Day 17 (3-bit VM implementation)
```

---

## Usage: Step-by-Step Workflow

### **Phase 1: Problem Understanding (5-10 minutes)**

```
YOU: [Copy paste AoC problem statement]

1. INVOKE: Problem Analyzer Agent
   INPUT: Full problem text + example

   Agent returns:
   - 8-step analysis
   - Identified pattern
   - Recommended algorithm
   - List of edge cases

2. REVIEW: Do you understand the problem?
   - Ask clarifying questions if confused
   - Verify example trace matches your understanding

3. INVOKE: Edge Case Hunter Agent
   INPUT: Problem statement + Problem Analyzer output

   Agent identifies:
   - Common gotchas
   - Off-by-one risks
   - Type mismatches
   - Boundary conditions
```

**Example Output**:
```
PROBLEM ANALYZER OUTPUT:
─────────────────────────
Goal: Find minimum steps from start to goal
World: 71×71 grid with corrupted cells
Algorithm: BFS (unweighted shortest path)
Complexity: O(grid²) ≈ 5000 operations

EDGE CASE HUNTER OUTPUT:
──────────────────────────
⚠️ Input format: "X,Y" not "Y,X"
⚠️ Grid bounds: 0-70 = 71 cells
⚠️ First 1024 bytes ONLY for Part 1
⚠️ Path might become impossible (affects Part 2!)
```

---

### **Phase 2: Algorithm Selection (2-5 minutes)**

```
4. INVOKE: Algorithm Selector Agent
   INPUT: Problem Analyzer output + Problem Analyzer's pattern ID

   Agent returns:
   - Detailed algorithm explanation
   - Why it fits this problem
   - Time/space complexity
   - Alternative approaches

5. INVOKE: Data Structure Advisor Agent (if algorithm is complex)
   INPUT: Algorithm recommendation + operation frequency analysis

   Agent returns:
   - Recommended data structures
   - Performance reasoning
   - Alternative structures & tradeoffs
```

**Example Output**:
```
ALGORITHM SELECTOR OUTPUT:
──────────────────────────
Algorithm: Breadth-First Search (BFS)
Why: Unweighted grid, guaranteed shortest path
Complexity: O(grid² × operations per cell) ≈ 50ms

BFS Queue: Use Deque<(Point, Int)>
  - popFirst() must be O(1)
  - Array.removeFirst() is O(n) ❌
  - Collections.Deque is O(1) ✅

DATA STRUCTURE ADVISOR OUTPUT:
──────────────────────────────
Corrupted cells: Set<Point> (O(1) lookup vs O(n) array)
  - Called ~100,000 times in BFS
  - Set is 200x faster

BFS queue: Deque<(Point, Int)>
  - FIFO requirement
  - O(1) append and popFirst essential

Visited tracking: Set<Point>
  - O(1) insert and lookup
```

---

### **Phase 3: Implementation Planning (5 minutes)**

```
6. INVOKE: Specialist Agent (if needed)
   INPUT: Algorithm + algorithm details

   For Graph problems: Graph Theory Expert
   For equation problems: Linear Algebra Expert
   For parsing: String Matching Expert
   For simulation: VM Expert

   Agent returns:
   - Implementation patterns
   - Common pitfalls
   - Code structure recommendations
```

**Example: Graph Theory Expert for BFS**
```
INPUT: "Implement BFS for shortest path on 71×71 grid"

OUTPUT:
────────
BFS PATTERN for Swift:
1. Import Collections for Deque
2. Create: queue, visited set, result
3. Loop: while queue not empty
   a. Pop first item
   b. Check if goal
   c. Add valid neighbors to queue
   d. Mark visited

Common Pitfalls:
- Don't add to queue without marking visited
  (leads to revisits and infinite loops)
- Don't forget bounds checking
- Deque is REQUIRED for O(1) popFirst()

Swift Implementation Template:
```swift
var queue = Deque<(point: Point, steps: Int)>()
var visited = Set<Point>()

queue.append((start, 0))
visited.insert(start)

while let (position, steps) = queue.popFirst() {
    if position == goal { return steps }

    for neighbor in position.orthogonalNeighbors() {
        guard isValid(neighbor) &&
              !corrupted.contains(neighbor) &&
              !visited.contains(neighbor)
        else { continue }

        queue.append((neighbor, steps + 1))
        visited.insert(neighbor)
    }
}
return -1
```
```

---

### **Phase 4: Implementation (Code, Test, Debug)**

```
7. YOU: Implement the solution
   - Use specialist's code template
   - Test with example input first

8. INVOKE: Edge Case Hunter Agent (revisit)
   INPUT: Your implementation + problem statement

   Agent checks:
   - Are you handling all edge cases?
   - Off-by-one errors?
   - Boundary conditions?

9. YOU: Run tests
   ./test <day>

10. IF FAILING:
    - Share error message with appropriate specialist
    - They help debug

11. IF PASSING TESTS BUT SLOW:
    - Invoke Performance Analyzer
```

---

### **Phase 5: Optimization (if needed)**

```
12. INVOKE: Performance Analyzer Agent
    INPUT: Working code + timing info

    Agent:
    - Identifies bottlenecks
    - Suggests optimizations
    - Warns about over-optimization

    Example: "BFS is O(grid²) which is fine.
             But you're calling string.contains()
             in the loop instead of Set.contains().
             This is your bottleneck!"
```

---

## Complete Workflow Example: Day 18

### **Step 1: Problem Analyzer**

```
INPUT: [Full Day 18 problem statement]

PROBLEM ANALYZER OUTPUT:
═══════════════════════════

Step 1 - GOAL:
  Find minimum steps from (0,0) to (70,70)
  avoiding corrupted coordinates

Step 2 - WORLD:
  71×71 grid (coordinates 0-70)
  Corrupted cells block movement
  4-directional movement only

Step 3 - CONSTRAINTS:
  Only use first 1024 bytes
  Can't move through corrupted cells
  Must reach (70,70)

Step 4 - INPUT:
  Format: "X,Y" per line
  Coordinates given in order

Step 5 - EXAMPLE TRACE:
  7×7 grid, 12 bytes
  Manually trace: path is 22 steps ✓

Step 6 - ALGORITHM:
  "Minimum steps" + "path" = BFS

Step 7 - EDGE CASES:
  ⚠️ X,Y order matters
  ⚠️ Grid is 71×71 not 70×70
  ⚠️ First 1024 ONLY
  ⚠️ Path can become impossible

Step 8 - DATA STRUCTURES:
  Corrupted: Set<Point>
  Queue: Deque<(Point, Int)>
  Visited: Set<Point>

SUMMARY: BFS shortest path problem.
         Use Set for O(1) lookups.
         Grid size and byte count configurable.
```

### **Step 2: Algorithm Selector**

```
INPUT: Problem Analyzer output (identified as BFS)

ALGORITHM SELECTOR OUTPUT:
════════════════════════════

Algorithm: Breadth-First Search

Why BFS:
- Unweighted graph (each step = 1 unit)
- Finds shortest path guaranteed
- First time reaching goal = answer
- Grid exploration level-by-level

Complexity:
- Time: O(grid²) ≈ 71² = 5,000 operations
- Space: O(grid²) for visited set
- Expected: ~5ms ✓

Data Structure Critical Choices:
1. Queue: MUST use Deque (O(1) popFirst)
   Array.removeFirst() would be O(n) ❌
2. Corrupted cells: Set (O(1) lookup)
3. Visited: Set (O(1) insert/lookup)
```

### **Step 3: Edge Case Hunter**

```
INPUT: Problem statement + Problem Analyzer output

EDGE CASE HUNTER OUTPUT:
═════════════════════════

Critical Gotchas Found:

1. ✓ Input Format
   "5,4" means X=5, Y=4
   NOT Y=5, X=4
   This is EASY to swap!

2. ✓ Grid Size
   "0-70" means 71 cells, not 70
   Goal: (70, 70), not (71, 71)
   Off-by-one risk: HIGH

3. ✓ Byte Count
   Part 1: "first 1024 bytes"
   NOT "all bytes"
   Hints that Part 2 changes this

4. ✓ Impossible Paths
   Bytes can block the path
   Function should return -1 if no path
   This affects Part 2 strategy!

5. ✓ Bounds Checking
   Must validate 0 <= x <= 70 AND 0 <= y <= 70
   Off-by-one risk: HIGH

6. ✓ Visited Tracking
   Mark visited BEFORE adding to queue
   (not after popping)
   Otherwise: revisits and infinite loops
```

### **Step 4: Graph Theory Expert**

```
INPUT: "Implement BFS for 71×71 grid pathfinding"

GRAPH THEORY EXPERT OUTPUT:
═════════════════════════════

BFS for Grid Pathfinding - Swift Implementation:

Key Pattern:
1. Queue holds: (position, steps_count)
2. Visited set prevents revisits
3. For each position, try 4 orthogonal neighbors
4. Return steps when goal reached

Swift Template:

```swift
func findShortestPath(gridSize: Int, byteCount: Int) -> Int {
    let corrupted = Set(coordinates.prefix(byteCount))
    let goal = Point(gridSize, gridSize)

    var queue = Deque<(point: Point, steps: Int)>()
    var visited = Set<Point>()

    queue.append((.init(0, 0), 0))
    visited.insert(.init(0, 0))

    while let (position, steps) = queue.popFirst() {
        if position == goal { return steps }

        for neighbor in [
            Point(position.x + 1, position.y),
            Point(position.x - 1, position.y),
            Point(position.x, position.y + 1),
            Point(position.x, position.y - 1)
        ] {
            guard neighbor.x >= 0 && neighbor.x <= gridSize &&
                  neighbor.y >= 0 && neighbor.y <= gridSize &&
                  !corrupted.contains(neighbor) &&
                  !visited.contains(neighbor)
            else { continue }

            queue.append((neighbor, steps + 1))
            visited.insert(neighbor)
        }
    }

    return -1  // No path found
}
```

Common Mistakes to Avoid:
- Don't forget to mark visited BEFORE adding to queue
- Don't use Array for queue (O(n) removeFirst is too slow)
- Do check BOTH x and y bounds
- Do return -1 if no path exists
```

### **Step 5: Implement & Test**

```
YOU: Write the code using templates above
     Run: ./test 18

If tests pass:
  - Part 1: 250 steps ✓
  - Proceed to Part 2

If tests fail:
  - Edge Case Hunter helps debug
  - Check: coordinates order, grid size, bounds
```

### **Step 6: Part 2 - Recognize Pattern**

```
INPUT: "Find first byte that blocks the path"

PROBLEM ANALYZER OUTPUT:
════════════════════════

This is a DIFFERENT problem!

Goal: "First X that blocks path"
Key Insight: Once blocked, stays blocked (MONOTONIC)
New Algorithm: Binary search on byte count

Why Binary Search:
- Naive: Try each byte (3450 iterations × 5ms) = 17 seconds ❌
- Binary: log₂(3450) ≈ 12 iterations × 5ms = 60ms ✅
- Speedup: 280x!

The Elegant Part:
- Reuse findShortestPath() from Part 1
- Call it with different parameters
- Binary search for transition point

```

### **Step 7: Implement Part 2**

```swift
func part2() async -> Int {
    var left = 0
    var right = coordinates.count - 1

    while left < right {
        let mid = (left + right) / 2
        if findShortestPath(gridSize: 70, byteCount: mid + 1) >= 0 {
            left = mid + 1  // Path exists, go later
        } else {
            right = mid     // Blocked, go earlier
        }
    }

    let blockingByte = coordinates[left]
    print("First blocking byte: \(blockingByte.x),\(blockingByte.y)")
    return 0
}
```

---

## Quick Reference: When to Invoke Each Agent

| Scenario | Agent | Input | Output |
|----------|-------|-------|--------|
| New AoC problem | Problem Analyzer | Problem statement | 8-step analysis |
| Confused about approach | Algorithm Selector | Problem + pattern | Algorithm explanation |
| Code is correct but slow | Data Structure Advisor | Code + performance profile | Better data structures |
| Implementation failing | Edge Case Hunter | Problem + code | Gotchas list |
| Need coding guidance | Specialist (domain) | Algorithm type | Code template |
| Want to optimize | Performance Analyzer | Code + timing | Bottleneck analysis |
| Debugging complex logic | Specialist (domain) | Error message | Debug guidance |

---

## Pro Tips

### **1. Always Start with Problem Analyzer**
Even if the problem seems obvious, 5 minutes of structured analysis prevents hours of debugging.

### **2. Use Templates from Specialists**
Copy their code structures. Don't waste time bikeshedding implementation details.

### **3. Test with Examples FIRST**
Before running real input, test with the example from Problem Analyzer's trace.

### **4. Ask for Specifics**
Instead of: "Why is my code slow?"
Ask: "My code passes tests but takes 2 seconds. Is it algorithmic or data structure?"

### **5. Recognize Part 2 Patterns**
- Part 1: Algorithm X (e.g., BFS)
- Part 2: Often "first X that" → Binary search on algorithm X
- Save Part 1 code and reuse it!

### **6. Don't Over-Optimize Part 1**
If Part 1 works, stop optimizing. Part 2 might reuse it with different parameters.

---

## Expected Time Savings

| Stage | Without Agents | With Agents | Savings |
|-------|---|---|---|
| Understanding | 15-30 min | 5-10 min | 2-4x |
| Algorithm selection | 10-20 min | 2-3 min | 5-10x |
| Data structure bugs | Varies | 1-2 min | Prevents hours |
| Implementation | 20-40 min | 15-30 min | 1-2x |
| Debugging | 10-30 min | 5-10 min | 2-3x |
| **Total per problem** | **1-2 hours** | **30-60 min** | **2-3x faster** |

With the agent stack, you should solve each day in 30-60 minutes (compared to typical 1-2 hours).

---

## Implementation Status

- [x] Architecture designed
- [x] Agent specifications documented
- [x] Workflow defined
- [x] Example walkthrough (Day 18)
- [ ] Ready to use with Claude Code

**Next**: Start using this stack on Day 20!

