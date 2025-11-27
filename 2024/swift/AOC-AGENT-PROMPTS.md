# AoC Agent Stack - Prompt Templates

> **Copy-paste ready prompts for invoking each agent**
>
> **Time saved**: 5-10 minutes per problem just by having good prompts

---

## Overview

Each section has a complete, copy-paste ready prompt for each agent. Just fill in the `[BRACKETED]` parts with your specific problem details.

---

## 1. PROBLEM ANALYZER AGENT

**When to use**: Start of EVERY AoC problem
**Time investment**: 5-10 minutes
**ROI**: Prevents 30+ minutes of debugging later

### Prompt Template

```
I'm solving Advent of Code [DAY XX: TITLE].

Use the 8-step Problem Decomposition framework to analyze this:

[PASTE FULL PROBLEM STATEMENT]

Example input:
[PASTE EXAMPLE INPUT]

Expected output:
[PASTE EXPECTED ANSWER]

For each step, be explicit and concrete:

1. GOAL: What is the final answer we need to find?
2. WORLD: What is the environment/space we're working in?
3. CONSTRAINTS: What are the rules? What's NOT allowed?
4. INPUT: How is data provided? What format?
5. TRACE: Walk through the example manually step-by-step
6. ALGORITHM: What CS pattern/technique does this match?
7. EDGE CASES: What could go wrong? What's easy to get wrong?
8. DATA STRUCTURES: What data structures fit this problem?

End with: "This is a [PATTERN] problem requiring [ALGORITHM]"
Expected complexity: O(?) ≈ [timing]"
```

### Expected Output

The agent will return something like:

```
PROBLEM DECOMPOSITION: Day 18 - RAM Run
════════════════════════════════════════

1. GOAL:
   Find the minimum number of steps from (0,0) to (70,70)
   while avoiding corrupted coordinates

2. WORLD:
   71×71 grid with coordinates 0-70 in both dimensions
   Some coordinates are "corrupted" (can't pass through)
   Start: (0,0), End: (70,70)

3. CONSTRAINTS:
   - 4-directional movement only (up, down, left, right)
   - Cannot move through corrupted cells
   - Must stay within grid bounds (0-70)
   - For Part 1: only use first 1024 corrupted bytes

4. INPUT:
   Format: Each line contains "X,Y" coordinates
   Order matters: byte 0, byte 1, byte 2, etc.
   Important: X,Y order NOT Y,X

5. TRACE:
   Example: 7×7 grid, use first 12 bytes
   [Walking through manually...]
   Expected: 22 steps ✓

6. ALGORITHM:
   "minimum steps" + "path" + "unweighted grid" → BFS
   Breadth-First Search finds shortest path

7. EDGE CASES:
   ⚠️ X,Y order (not Y,X) - EASY to swap!
   ⚠️ 0-70 means 71 cells, not 70
   ⚠️ "First 1024" not "all bytes"
   ⚠️ Path can become impossible (hints at Part 2!)
   ⚠️ Grid size changes between test and real (7 vs 71)

8. DATA STRUCTURES:
   - Corrupted cells: Set<Point> for O(1) lookup
   - BFS queue: Deque<(Point, Int)> for O(1) pop
   - Visited tracking: Set<Point> for O(1) insert/lookup

SUMMARY: This is a BFS shortest path problem.
Complexity: O(grid² × operations) ≈ ~5ms expected
Critical: Use Set (not Array) for membership testing
```

---

## 2. ALGORITHM SELECTOR AGENT

**When to use**: When you're not 100% sure about the algorithm
**Time investment**: 2-5 minutes
**ROI**: Prevents implementing wrong algorithm

### Prompt Template

```
The Problem Analyzer identified my problem as: "[PATTERN] problem"
The recommended algorithm is: [ALGORITHM]

I need deep understanding:

1. Why does [ALGORITHM] fit this problem specifically?
2. What's the basic implementation pattern?
3. What are the time and space complexity?
4. Common mistakes people make with this algorithm?
5. When would [ALTERNATIVE ALGORITHM] be better?

Provide reasoning, not just a name.
```

### Example Usage

```
The Problem Analyzer identified my problem as: "Shortest path problem"
The recommended algorithm is: Breadth-First Search (BFS)

I need deep understanding:

1. Why does BFS fit this problem specifically?
2. What's the basic implementation pattern?
3. What are the time and space complexity?
4. Common mistakes people make with BFS?
5. When would Dijkstra be better than BFS?

Provide reasoning, not just a name.
```

### Expected Output

```
Why BFS Fits:
- Your problem has an UNWEIGHTED graph (each step costs 1)
- You want the SHORTEST path
- BFS explores level-by-level, guaranteeing shortest path
- First time reaching goal = answer

Alternative: Dijkstra would work but is overkill for uniform costs

Time Complexity: O(V + E) where V=cells, E=edges between cells
For 71×71 grid: O(71²) ≈ 5000 operations

Common Mistakes:
1. Using DFS (wrong - doesn't guarantee shortest)
2. Not marking visited (causes infinite loops)
3. Using Array.removeFirst() (O(n) instead of O(1))
```

---

## 3. DATA STRUCTURE ADVISOR AGENT

**When to use**: Before coding the main algorithm
**Time investment**: 2-3 minutes
**ROI**: 280x speedup (as seen in Day 18!)

### Prompt Template

```
I'm implementing [ALGORITHM] for my problem.

Here's what I need to do:
1. [Operation 1 - describe it and how often it's called]
2. [Operation 2 - describe it and how often it's called]
3. [Operation 3 - describe it and how often it's called]

Which data structures should I use in Swift?
For each, tell me:
- WHY this structure (not alternatives)
- O(?) cost for each operation
- Any gotchas or setup needed
- Swift syntax/imports
```

### Example Usage

```
I'm implementing BFS for pathfinding.

Here's what I need to do:
1. Check if a coordinate is corrupted - millions of times (called in inner loop)
2. Add/remove items from queue - thousands of times (FIFO order)
3. Mark cells as visited - thousands of times (O(1) both insert and lookup)

Which data structures should I use in Swift?
For each, tell me:
- WHY this structure (not alternatives)
- O(?) cost for each operation
- Any gotchas or setup needed
- Swift syntax/imports
```

### Expected Output

```
DATA STRUCTURE RECOMMENDATIONS
═══════════════════════════════

1. Corrupted Coordinates:
   ✅ Use: Set<Point>
   ❌ Don't: Array<Point>

   Why: You check contains() millions of times
   - Set: O(1) per check = 5ms total ✅
   - Array: O(n) per check = 2+ seconds ❌
   - Difference: 280x speedup!

   Setup:
   ```swift
   let corrupted = Set(coordinates.prefix(1024))
   if corrupted.contains(point) { ... }
   ```

2. BFS Queue:
   ✅ Use: Deque<(Point, Int)>
   ❌ Don't: Array<(Point, Int)>

   Why: You need efficient popFirst()
   - Deque: O(1) popFirst() ✅
   - Array: O(n) removeFirst() ❌

   Imports: import Collections
   ```swift
   var queue = Deque<(point: Point, steps: Int)>()
   queue.append((position, steps + 1))
   let (pos, steps) = queue.popFirst()
   ```

3. Visited Tracking:
   ✅ Use: Set<Point>
   Similar reasoning to #1: O(1) insert/lookup
```

---

## 4. EDGE CASE HUNTER AGENT

**When to use**: Before coding AND if tests fail
**Time investment**: 2-3 minutes
**ROI**: Catches bugs before they waste hours

### Prompt Template (Before Coding)

```
Before I start coding, help me avoid gotchas.

Problem: [BRIEF DESCRIPTION]

Potential issues I should watch for:
- Coordinate order? (X,Y vs Y,X)
- Off-by-one errors? (0-70 means 71 items?)
- Order sensitivity? (Does sequence matter?)
- Exact vs approximate numbers? (First 1024 vs up to 1024?)
- Type mismatches? (Problem wants coordinates, framework wants int?)
- Impossible states? (What if no solution exists?)
- Index bounds? (Can I access array[i+1]?)

List specific gotchas for THIS problem, not generic ones.
Give warnings ⚠️ for HIGH RISK items.
```

### Prompt Template (After Failing Tests)

```
My code is failing tests.

Problem statement excerpt: [RELEVANT PART]

My implementation:
[PASTE CODE]

Test error:
[PASTE ERROR OR DESCRIBE WRONG OUTPUT]

Check these specifically:
1. Off-by-one errors (0-N ranges)
2. Input format misunderstanding
3. Order/sequence assumptions
4. Edge case handling
5. Data type conversions

Where's the bug?
```

---

## 5. SPECIALIST AGENT TEMPLATES

### 5A. Graph Theory Expert

**When to use**: For BFS, DFS, pathfinding, graph traversal problems
**Time investment**: 2-3 minutes

```
I'm implementing [BFS/DFS/topological sort] for a [grid/graph] problem.

My specific needs:
- [Describe the graph structure]
- [Describe what I'm looking for]
- [Describe constraints on movement]

Provide:
1. Swift code template for [ALGORITHM]
2. Explanation of key pattern
3. Common mistakes to avoid
4. Why [alternate algorithm] wouldn't work as well
```

### 5B. Linear Algebra Expert

**When to use**: For equation solving, matrix problems, button presses
**Time investment**: 3-5 minutes

```
I have a system of equations to solve:

[Equation 1]
[Equation 2]
[etc.]

I need to find: [What variables to solve for]

Approach:
1. How do I solve this in Swift?
2. Do I use Gaussian elimination or substitution?
3. Can I use brute force or must I be clever?
4. What's the performance?

Show me the implementation.
```

### 5C. Number Theory Expert

**When to use**: For modular arithmetic, cycles, GCD/LCM problems
**Time investment**: 2-3 minutes

```
My problem involves: [DESCRIBE PATTERN]

Specific question:
- [What mathematical property]
- [How to detect or use it]
- [How to optimize with it]

Application:
1. How does [NUMBER THEORY CONCEPT] help?
2. Swift implementation?
3. Performance improvement?
4. Any edge cases?

Make it concrete to my problem, not generic.
```

### 5D. String Matching Expert

**When to use**: For parsing, regex, string decomposition problems
**Time investment**: 2-3 minutes

```
I need to match strings according to this problem:

[PASTE PROBLEM EXCERPT]

Specifically:
1. Match patterns: [DESCRIBE]
2. Decompose strings: [DESCRIBE]
3. Validation: [DESCRIBE]

Provide:
1. Parsing approach (regex vs parsing library vs manual?)
2. Swift implementation
3. Edge cases for strings
4. Performance considerations
```

### 5E. Virtual Machine/Simulation Expert

**When to use**: For CPU simulation, state machines, complex simulations
**Time investment**: 3-5 minutes

```
I'm building a simulator/VM with:

State:
[List registers/variables]

Instructions:
[List operations]

Constraints:
[Movement rules, transitions]

Provide:
1. Struct layout for state
2. Instruction dispatch pattern
3. How to handle state changes
4. Common bugs to avoid (double-increment, bounds, etc.)
5. Testing approach

Swift code template.
```

---

## 6. PERFORMANCE ANALYZER AGENT

**When to use**: When code works but seems slow
**Time investment**: 3-5 minutes
**ROI**: Identifies where your 10x speedup is hiding

### Prompt Template

```
My code works but runs slow.

Problem: [DESCRIPTION]
Expected time: [X] ms
Actual time: [Y] ms
Ratio: Too slow by [Z]x

My approach:
1. Algorithm: [NAME AND DESCRIPTION]
2. Data structures: [LIST]
3. Main loop structure: [DESCRIBE ITERATIONS]
4. Bottleneck operation: [GUESS]

Questions:
1. Is this algorithmic (wrong algorithm) or implementation (wrong data structure)?
2. Where's the actual bottleneck?
3. What should I optimize first?
4. How much speedup is realistic?

Show me the profiling approach and optimization.
```

### Example Usage

```
My code works but runs slow.

Problem: Find first byte blocking path (similar to Day 18)
Expected time: 50-60 ms
Actual time: 17+ seconds (280x too slow!)

My approach:
1. Algorithm: Linear search + BFS for each byte
2. Data structures: Set for corrupted, Deque for queue
3. Main loop: For each byte 0..3450, run BFS
4. Bottleneck operation: I think it's the repeated BFS calls?

Questions:
1. Is this algorithmic (wrong algorithm) or implementation (wrong data structure)?
2. Where's the actual bottleneck?
3. What should I optimize first?
4. How much speedup is realistic?

Show me the profiling approach and optimization.
```

---

## Quick Reference: Which Agent for Each Situation

| Situation | Agent | Prompt Name |
|-----------|-------|-------------|
| Just got new problem | Problem Analyzer | "8-step decomposition" |
| Not sure about algorithm | Algorithm Selector | "Why does [algo] fit?" |
| About to code | Data Structure Advisor | "Which data structures?" |
| Worried about bugs | Edge Case Hunter | "Help me avoid gotchas" |
| Code fails tests | Edge Case Hunter | "My code is failing" |
| Need code template | Specialist (domain) | "[Algorithm] template" |
| Code works but slow | Performance Analyzer | "Code works but slow" |
| Don't understand algorithm | Algorithm Selector | "Deep explanation" |
| Complex math/equations | Specialist (domain) | "Solve this system" |
| Can't parse input | Specialist (String) | "String parsing help" |

---

## Pro Tips for Best Results

### ✅ **DO**

1. **Be specific about numbers**
   - ✅ "Called millions of times in inner loop"
   - ❌ "Called a lot"

2. **Paste actual code or problem text**
   - ✅ [PASTE ACTUAL PROBLEM EXCERPT]
   - ❌ "The problem says something about a grid"

3. **State what you've already tried**
   - ✅ "I tried using Array but it's too slow"
   - ❌ "It doesn't work"

4. **Ask for specific output**
   - ✅ "Provide: 1) why this fits, 2) complexity, 3) template"
   - ❌ "Help me with this"

5. **Include constraints and examples**
   - ✅ "Grid is 71×71, bytes 0-3450, example shows 22 steps"
   - ❌ "It's a grid problem"

### ❌ **DON'T**

1. Skip the Problem Analyzer (even if problem seems easy)
2. Ask vague questions ("How do I solve this?")
3. Use generic prompts (these are customized!)
4. Ignore agent recommendations
5. Optimize before having working code

---

## Complete Workflow Using Prompts

Here's an actual execution for Day 18:

### **Step 1**: Problem Analyzer (Copy from Prompt #1)
```
[Fill in: problem statement, example, expected output]
[Send to Claude]
[Get: 8-step analysis]
```

### **Step 2**: Algorithm Selector (Copy from Prompt #2)
```
The Problem Analyzer identified my problem as: "shortest path"
The recommended algorithm is: BFS

I need deep understanding:
1. Why does BFS fit...
```

### **Step 3**: Data Structure Advisor (Copy from Prompt #3)
```
I'm implementing BFS for pathfinding.

Here's what I need to do:
1. Check if corrupted...
2. Add/remove queue items...
3. Mark visited...
```

### **Step 4**: Specialist Template (Copy from Graph Theory section)
```
I'm implementing BFS for a grid problem.

My specific needs:
- 71×71 grid, 4-directional movement
- Find shortest path avoiding corrupted cells
- Return steps count or -1 if impossible

Provide:
1. Swift code template...
```

### **Step 5**: You code it up, test with `./test 18`

### **Step 6**: If tests pass, recognize Part 2 pattern (copy Prompt #2 again)
```
"Part 2 asks for FIRST byte that blocks.
Is this a different algorithm? Can I reuse BFS?"
```

### **Step 7**: Binary search template (from Algorithm Selector)
```
"Implement binary search that calls my BFS function
with different byteCount parameters"
```

**Result**: Both parts solved in ~45 minutes instead of 1-2 hours

---

## Saving Your Prompts

### **In Claude Code**:
1. Create folder: `.claude/aoc-prompts/`
2. Save each prompt as `.md` file
3. Reference them as you work

### **As Shell Aliases** (optional):
```bash
# ~/.bashrc or ~/.zshrc
alias aoc-problem="echo 'Paste this prompt...'"
alias aoc-algorithm="echo 'Paste this prompt...'"
```

### **In Notes App**:
Screenshot or save the key prompts you use most

---

## Next: Your First Problem Using Agents

You have:
- ✅ Architecture (AOC-AGENT-STACK.md)
- ✅ Workflow (AOC-AGENT-QUICK-START.md)
- ✅ Prompts (this file)

**Ready to try Day 20?**

1. Open Day 20 problem on adventofcode.com
2. Copy the full problem statement
3. Paste into Claude Code
4. Use Prompt #1: Problem Analyzer
5. Follow the workflow

Expected time: 30-60 minutes total

You've got this! 🚀

---

*Created: November 11, 2024*
*Status: Ready to deploy*
*Update frequency: After each successful day*

