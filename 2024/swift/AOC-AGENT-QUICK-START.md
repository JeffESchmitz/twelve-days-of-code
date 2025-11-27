# AoC Agent Stack - Quick Start Guide

> **How to use the agent group in practice**
>
> **For**: Solving Advent of Code 2024 puzzles efficiently
>
> **Time per problem**: 30-60 minutes (vs 1-2 hours without agents)

---

## Two Workflow Paths

### **Fast Mode (30-45 min)**: Direct agent calls
- Just solve the puzzle quickly
- Use other agents directly
- Less interactive

### **Learning Mode (45-90 min)**: Through Puzzle Teacher
- Understand how to solve puzzles
- Build transferable skills
- Interactive Socratic questions
- Pattern recognition

Choose based on your goal!

---

## The Workflow in 6 Steps (Fast Mode)

### **Step 1: Problem Understanding (5-10 min)**

You've just opened a new AoC problem. Do this:

```
1. Copy the problem statement from adventofcode.com
2. Get the example input and expected output
3. Open Claude Code
4. Send to Claude:

"I'm solving Advent of Code [Day XX: Title].
Use the 8-step Problem Decomposition framework to analyze this:

[PASTE FULL PROBLEM TEXT]

Example input:
[PASTE EXAMPLE]

Expected output:
[PASTE EXPECTED]

Break this down systematically using:
1. GOAL
2. WORLD
3. CONSTRAINTS
4. INPUT FORMAT
5. TRACE EXAMPLE
6. ALGORITHM PATTERN
7. EDGE CASES
8. DATA STRUCTURES

End with: This is a [PATTERN] problem requiring [ALGORITHM]."
```

**What you get**:
- Clear understanding of the problem
- Identified algorithm
- List of gotchas to watch for
- Data structure recommendations

**Expected output format**:
```
PROBLEM DECOMPOSITION
═══════════════════════

1. GOAL:
   Find [X], where [description]

2. WORLD:
   [Environment description]

3. CONSTRAINTS:
   [Rules and limitations]

4. INPUT:
   [How data is formatted]

5. EXAMPLE TRACE:
   [Walking through the example step by step]
   Expected: [answer]

6. ALGORITHM:
   "keywords from problem" → [ALGORITHM NAME]

7. EDGE CASES:
   ⚠️ [Gotcha 1]
   ⚠️ [Gotcha 2]
   ...

8. DATA STRUCTURES:
   - [Structure 1] for [purpose]
   - [Structure 2] for [purpose]

SUMMARY: This is a [PATTERN] problem requiring [ALGORITHM].
Complexity: O(?) ≈ [expected time]
```

---

### **Step 2: Algorithm Deep Dive (2-5 min)**

If you're not 100% confident in the algorithm, ask Claude:

```
"The Problem Analyzer identified this as a [ALGORITHM] problem.

I need to understand:
1. Why [ALGORITHM] fits this problem
2. The basic implementation pattern in Swift
3. Common mistakes I should avoid
4. Complexity analysis

Provide a code template showing the core pattern."
```

**What you get**:
- Clear explanation why this algorithm fits
- Swift code template
- Performance expectations
- Common pitfalls list

---

### **Step 3: Before Coding - Data Structures (2-3 min)**

Ask Claude about the data structures:

```
"For my [ALGORITHM] implementation, I need to:

1. [Store X and check if Y frequently]
2. [Perform Z operations]
3. [Process items in FIFO order]

Which data structures should I use in Swift?
Why? (performance reasoning)
What are the O(?) costs?"
```

**What you get**:
- Best-fit data structures
- Performance reasoning
- Why NOT to use alternatives
- Swift syntax

**Example responses**:
```
For membership testing called millions of times:
❌ Array (O(n))
✅ Set (O(1))
Performance difference: 200x in this problem

For queue operations:
❌ Array.removeFirst() (O(n))
✅ Deque.popFirst() (O(1))
From Collections package
```

---

### **Step 4: Implementation Checkpoint (30-45 min)**

Before starting, ask for:

```
"Give me the complete code template for [ALGORITHM] in Swift.

Include:
1. Imports needed
2. Data structure setup
3. Main loop structure
4. Base cases and exits
5. Return statement

Template should be ready to fill in with my specific problem details."
```

**Then YOU**:
1. Write the code using the template
2. Run: `./test <day>`
3. If example test passes → great!
4. If it fails → next step

---

### **Step 5: Debugging (if needed)**

If tests fail:

```
"My code is failing. Here's what I have:

[PASTE YOUR CODE]

Test output:
[PASTE ERROR]

Problem statement says: [RELEVANT PART]

Where's my mistake? Check:
1. Off-by-one errors
2. Order/format issues
3. Boundary conditions
4. Data structure misuse"
```

**Claude will**:
- Find the exact bug
- Explain why it happens
- Show the fix
- Explain the lesson

---

### **Step 6: Performance Check (if slow)**

If code works but seems slow:

```
"My code passes tests but takes [X seconds].
Expected: [Y ms]

My approach:
1. [Description of algorithm]
2. [Data structures used]
3. [Main loop iterations]

Is this an algorithmic problem or data structure problem?
Where's the bottleneck? How do I optimize?"
```

**Claude will**:
- Identify if it's truly slow
- Pinpoint the bottleneck
- Suggest optimization
- Show expected speedup

---

## Complete Example: Using Agents to Solve a Problem

Let's say you're solving Day 20 (fictional):

### **Your Input** (Copy from AoC):

```
Oh no! You forgot to update your position tracking.

You need to figure out whether a shortcut in a racetrack
helps you win a race.

Here's how it works:
- You have a racetrack layout
- You can cheat by going through walls ONCE
- Find how much time you save by cheating

[Full problem with grid and examples...]

Example:
@@@@@@@
@.....@
@.###.@
@...#.@
@.###.@
@..@..@
@@@@@@@

Expected: 64 time saved
```

### **Your Request #1: Problem Analyzer**

```
"Problem Analysis for Day 20: Racetrack Shortcut

[PASTE FULL PROBLEM]

Example above. Expected: 64 time saved.

Use 8-step framework to decompose this."
```

### **Claude's Response** (Problem Analyzer Agent):

```
PROBLEM DECOMPOSITION
═══════════════════════

1. GOAL:
   Find how much time is saved by cheating
   (going through walls once)

2. WORLD:
   Grid-based racetrack
   '@' = wall, '.' = track, 'S' = start, 'E' = end
   Must find path and measure savings

3. CONSTRAINTS:
   Can only cheat ONCE
   Cheat = move through one wall
   Limited cheat length (maybe 2 steps?)

4. INPUT:
   Grid map with walls and open spaces

5. EXAMPLE TRACE:
   Without cheat: track = 84 steps
   With cheat: through wall = 20 steps
   Saving: 64 steps

6. ALGORITHM:
   This requires:
   - Part 1: BFS for normal shortest path
   - Part 2: Try all wall positions, for each wall try
     cheating through it, measure savings
   Pattern: "All possible shortcuts" → Brute force + BFS

7. EDGE CASES:
   ⚠️ Cheat must save time (not make longer)
   ⚠️ Cheat goes through exactly 1 wall
   ⚠️ Cheat has length limit (2-3 steps?)
   ⚠️ Multiple equally-short cheats possible

8. DATA STRUCTURES:
   - Set<Point> for corrupted/walls
   - Deque for BFS queue
   - Dictionary to store distances from start/end
   - Array of cheats with their savings

SUMMARY: This is a BFS + brute force enumeration problem.
Need to:
1. Run BFS normally (find base path)
2. Try cheating through each wall
3. For each cheat, run BFS again
4. Track maximum savings

Complexity: O(grid² × wall_count × grid²)
Could be optimized with clever distance calculations
```

### **Your Request #2: Check Data Structures**

```
"For my BFS implementation in this problem:
1. I need to mark walls (can't walk through normally)
2. For cheating, I temporarily allow walking through ONE wall
3. I need to count distances

What data structures and approach?"
```

### **Claude's Response** (Data Structure Advisor):

```
RECOMMENDED APPROACH
═══════════════════════

Two BFS passes per cheat attempt:
1. BFS from start → distances to each cell
2. BFS from end → distances from each cell
3. For each wall, calculate: distance_from_start + cheat_cost + distance_to_end

Data Structures:
- walls: Set<Point> (O(1) lookup when checking if cell is wall)
- distancesFromStart: [Point: Int]
- distancesFromEnd: [Point: Int]
- BFS queue: Deque<(Point, Int)>

Key optimization:
Instead of BFS per wall, compute distances once,
then check all possible cheats mathematically.

This is O(grid² + walls²) instead of O(walls × grid²)
Much faster!
```

### **Your Request #3: Code Template**

```
"Give me the Swift template for this solution:
1. BFS function that tracks distances
2. Main logic that tries all wall shortcuts
3. Returns max time saved

Include setup, imports, etc."
```

### **Claude's Response** (Specialist Agent):

```swift
import Collections

func part1() async -> Int {
    // 1. Compute distances from start
    let distFromStart = bfs(from: start, walls: walls)

    // 2. Compute distances from end
    let distFromEnd = bfs(from: end, walls: walls)

    // 3. Try all possible single-step cheats
    var maxSavings = 0
    for wallPoint in walls {
        for neighbor in wallPoint.orthogonalNeighbors() {
            guard !walls.contains(neighbor) else { continue }

            // Path through this "cheat": start -> neighbor -> wallPoint -> rest
            let cheatedDist = (distFromStart[neighbor] ?? Int.max) +
                             1 +  // Through wall
                             (distFromEnd[wallPoint] ?? Int.max)

            let savings = normalDistance - cheatedDist
            maxSavings = max(maxSavings, savings)
        }
    }

    return maxSavings
}

func bfs(from start: Point, walls: Set<Point>) -> [Point: Int] {
    var distances: [Point: Int] = [start: 0]
    var queue = Deque<(point: Point, dist: Int)>()
    queue.append((start, 0))

    while let (position, dist) = queue.popFirst() {
        for neighbor in position.orthogonalNeighbors() {
            guard !walls.contains(neighbor),
                  distances[neighbor] == nil
            else { continue }

            distances[neighbor] = dist + 1
            queue.append((neighbor, dist + 1))
        }
    }

    return distances
}
```

---

## Alternative Workflow: Learning Mode (Puzzle Teacher)

If your goal is to **build deep understanding** instead of just solving:

### **Step 1: Invoke Puzzle Teacher (10-15 min)**

```
"I want to LEARN how to solve this problem, not just get the answer.

Use Puzzle Teacher mode with guided discovery:
1. Ask me questions about the problem
2. Don't tell me the algorithm—guide me to discover it
3. Have me EXPLAIN my thinking at each step
4. Point out patterns I should remember for future problems
5. Validate my understanding before I code

[PASTE PROBLEM]

Let's start: What do you think this problem is asking?"
```

### **Step 2: Teacher Guides Through 8 Steps (15-20 min)**

Teacher asks YOU questions:
- "What's the GOAL?" ← You answer
- "What's the WORLD?" ← You answer
- "What CONSTRAINTS?" ← You answer
- etc.

You EXPLAIN your thinking, Teacher VALIDATES it.

### **Step 3: Discover the Algorithm (10-15 min)**

Instead of being told:
```
TEACHER: "When we want SHORTEST path with equal costs,
          which algorithm comes to mind?"
YOU:     "BFS!"
TEACHER: "Why BFS and not DFS?"
YOU:     [Your explanation]
TEACHER: "Exactly! This pattern appears in [other problems too]..."
```

### **Step 4: Before Coding - Validation (5-10 min)**

```
TEACHER: "Before you write code, can you explain:
          1. Why this data structure?
          2. What's the bottleneck operation?
          3. What edge cases worry you?

          Convince me you're ready!"
```

### **Step 5: Code with Confidence (30-45 min)**

You code knowing you understand WHY, not just WHAT.

### **Step 6: Learning Reinforcement (5-10 min)**

```
TEACHER: "Great! Now let's solidify the learning:
          1. What pattern did we use?
          2. Where else might you see this?
          3. What will you remember next time?
          4. How does Part 2 change the approach?"
```

### **Result**
- ✅ Problem solved
- ✅ Pattern understood
- ✅ Transferable skill gained
- ✅ Ready for similar problems

---

## Choosing Your Path

| Goal | Path | Time | Payoff |
|------|------|------|--------|
| Solve the puzzle | Fast Mode | 30-45 min | ✅ Stars! |
| Learn patterns | Learning Mode | 45-90 min | ✅ Stars + Skills |
| Master problem-solving | Hybrid (mix both) | 60-90 min | ✅ Stars + Mastery |

**Recommended for AoC 2024**: **Learning Mode** for early days (1-10), then **Hybrid** mode as you master patterns.

---

## Real World Example: Day 18 (from your repo)

Here's how you'd actually use agents for Day 18:

### **Request 1**:
```
"8-step analysis for:

A large grid is slowly being corrupted by falling bytes...
After 1024 bytes, what's the minimum steps from (0,0) to (70,70)?

Grid is 71x71 (0-70 range)
Bytes are 'X,Y' coordinates
Example: 5,4 means coordinate (5,4) is corrupted

[Full problem pasted...]"
```

**Response**: BFS shortest path + data structure recommendations

### **Request 2**:
```
"Show me the Swift template for BFS on this grid using Deque.
Make it accept (gridSize, byteCount) parameters for testing."
```

**Response**: Code template with named tuple, Deque import, full loop

### **You write code, test**:
```bash
./test 18
# Tests pass!
```

### **Request 3** (for Part 2):
```
"Part 2 asks for the FIRST byte that makes path impossible.

Is this a different algorithm? Or can I reuse my Part 1 BFS?
Hint: The problem mentions it's when the path becomes impossible."
```

**Response**:
```
This is PERFECT for binary search!
1. Your BFS already finds if path exists
2. Property is MONOTONIC: once blocked, stays blocked
3. Binary search instead of trying all bytes

Binary search on byteCount parameter:
- If path exists with N bytes, blocker is at N+1..end
- If path blocked with N bytes, blocker is at ..N
- O(log n) iterations instead of O(n)

This reuses your Part 1 code 12 times instead of 3500 times!
280x speedup!
```

**You write**:
```swift
func part2() async -> Int {
    var left = 0, right = coordinates.count - 1

    while left < right {
        let mid = (left + right) / 2
        if findShortestPath(gridSize: 70, byteCount: mid + 1) >= 0 {
            left = mid + 1
        } else {
            right = mid
        }
    }

    let blocking = coordinates[left]
    print("Answer: \(blocking.x),\(blocking.y)")
    return 0
}
```

**Test**:
```bash
./run 18
# Both parts output correctly in ~60ms total
```

---

## The Key Commands You'll Use

Copy these exact commands for quick agent invocation:

### **1. Problem Understanding**
```
"8-step decomposition for [DAY XX: TITLE]:

[PASTE FULL PROBLEM TEXT]

Example input:
[PASTE]

Expected output:
[PASTE]"
```

### **2. Algorithm Selection**
```
"Why does [PROBLEM PATTERN] map to [ALGORITHM]?
Explain with Swift examples."
```

### **3. Data Structures**
```
"For [ALGORITHM] in this context:
- I need to [operation 1] frequently
- I need to [operation 2] frequently
- Best data structures? Why?
- Swift syntax?"
```

### **4. Code Template**
```
"Full Swift template for [ALGORITHM]:
- Imports
- Data structure setup
- Main loop
- Base cases
- Return

Make it reusable with parameters."
```

### **5. Debugging**
```
"Code fails on tests.

[PASTE CODE]

Error: [PASTE ERROR]

Check: off-by-one, format, bounds, data structure misuse"
```

### **6. Performance**
```
"Code works but slow ([X] seconds).

Bottleneck analysis:
- Algorithm type: [X]
- Data structures: [X]
- Main loop iterations: [X]

Why slow? How to optimize?"
```

---

## Pro Tips for Maximum Efficiency

### ✅ **DO**
- Start EVERY day with Problem Analyzer (even if obvious)
- Test with examples BEFORE real input
- Copy code templates from agents (don't rewrite)
- Ask specifics: "Why is this line here?" gets better answers
- Save good code templates to your notes

### ❌ **DON'T**
- Skip the 8-step analysis (costs more time later)
- Optimize Part 1 (might be replaced in Part 2)
- Ignore edge case warnings (they're specific)
- Use Array.removeFirst() in queues (O(n) disaster)
- Assume you understand the problem (re-read!)

---

## Expected Workflow Timeline

For a typical Day:

| Phase | Time | Agents | Output |
|-------|------|--------|--------|
| Problem Analysis | 5-10 min | Problem Analyzer | 8-step analysis |
| Understand Algorithm | 2-5 min | Algorithm Selector | Why this algorithm |
| Data Structures | 2-3 min | Data Structure Advisor | Which structures, why |
| Get Code Template | 2-3 min | Specialist | Swift template |
| **Coding + Testing** | **15-30 min** | You | Working code |
| Debug (if needed) | 5-10 min | Specialist | Bug fixes |
| Part 2 (reuse Part 1) | 5-10 min | Problem Analyzer | Recognition of pattern |
| **TOTAL** | **35-65 min** | Mixed | Both parts solved |

---

## Next Steps

1. **Save this file** in your repo
2. **Bookmark the agent stack architecture** (AOC-AGENT-STACK.md)
3. **Day 20**: Start your FIRST problem using this workflow
4. **Measure time**: Compare to your usual approach
5. **Iterate**: Ask agents for refinements

---

## Questions to Ask in Each Phase

### **Phase 1: Understanding**
- ✓ "What's the final answer I need?"
- ✓ "What environment am I working in?"
- ✓ "What are the constraints?"
- ✓ "What gotchas might I hit?"

### **Phase 2: Algorithm**
- ✓ "Why does this algorithm fit?"
- ✓ "What's the time complexity?"
- ✓ "What could go wrong?"
- ✓ "Are there alternatives?"

### **Phase 3: Data Structures**
- ✓ "Which operations are called most?"
- ✓ "What's the cost of each operation?"
- ✓ "Why not just use Array?"
- ✓ "Swift syntax for this?"

### **Phase 4: Implementation**
- ✓ "Give me a template"
- ✓ "Where exactly do I fill in my code?"
- ✓ "What imports do I need?"
- ✓ "Is this handling all edge cases?"

### **Phase 5: Debugging**
- ✓ "Why is this test failing?"
- ✓ "What assumption did I make wrong?"
- ✓ "How do I fix this bug?"
- ✓ "How do I prevent this in future?"

### **Phase 6: Optimization**
- ✓ "Where's the bottleneck?"
- ✓ "Is my algorithm wrong or my data structure?"
- ✓ "How much can I improve?"
- ✓ "Is optimization worth the complexity?"

---

## You're Ready! 🚀

Your agent stack is designed. You have the workflow. You have the templates.

**For Day 20**:
1. Open the problem
2. Send it to Claude with "8-step decomposition" request
3. Follow the workflow
4. Track how long it takes

Expected: **30-60 minutes instead of 1-2 hours**

Good luck, and happy coding!

---

*Updated: November 11, 2024*
*Ready to deploy on Day 20*

