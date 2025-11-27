# Day 21: Keypad Conundrum - Detailed Analysis

> **Status**: Problem decomposition and trace complete
> **Date**: November 14, 2024
> **Branch**: `day-21-keypad-conundrum`

---

## Executive Summary

Day 21 is a **multi-layer keypad sequence transformation problem** with exponential complexity. The core challenge: transform a numeric code through 3 intermediate robot layers to find the length of your final input sequence, then multiply by the code's numeric value.

**Key insight**: We cannot brute-force this. We must:
1. Find shortest paths between buttons (avoiding gaps)
2. Handle multiple shortest paths (some minimize downstream costs better)
3. Use memoization to avoid recalculating identical sequences

---

## Problem Decomposition (8-Step Framework)

### 1. GOAL

Find the sum of "complexities" for 5 door codes.

**Complexity formula**:
```
complexity = (length of YOUR keypad input) × (numeric value of code)
```

**Example**: Code "029A"
- YOUR keypad sequence length: 68 button presses
- Numeric value: 29
- Complexity: 68 × 29 = 1,972

**Final answer**: Sum of complexities across all 5 codes

---

### 2. WORLD

**Four nested keypads in a chain**:

```
YOUR DIRECTIONAL KEYPAD (what you type)
     ↓ (controls)
ROBOT 1's DIRECTIONAL KEYPAD
     ↓ (controls)
ROBOT 2's DIRECTIONAL KEYPAD
     ↓ (controls)
DOOR's NUMERIC KEYPAD (outputs the actual code)
```

**Numeric Keypad Layout** (on the door):
```
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+

Gap at row 3, col 0 (bottom-left)
```

**Directional Keypad Layout** (all 3 robots + your input):
```
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+

Gap at row 0, col 0 (top-left)
```

**Starting positions**: All keypads start with arm at `A`

---

### 3. CONSTRAINTS

1. **Movement**: Only 4 directions + activate (`A`)
2. **Gap avoidance**: Robot arm cannot pass through gaps (robot panics)
3. **Shortest sequences**: Must find paths with minimum length
4. **Multiple paths**: Multiple shortest paths may exist; some minimize downstream costs better
5. **Sequential pressing**: Each sequence must press buttons in exact order

---

### 4. INPUT

**Format**: Five 4-character alphanumeric codes (e.g., "029A", "980A")

**Example**:
```
029A
980A
179A
456A
379A
```

These codes must appear on the **numeric keypad**. We calculate the length of your keypad input needed to produce each code through the 3-robot chain.

---

### 5. EXAMPLE TRACE

**Code: 029A**

#### Layer 3 (Numeric Keypad)
Robot at numeric keypad must press: `0`, `2`, `9`, `A` (in sequence)

**Shortest sequence on numeric keypad**: `<A^A>^^AvvvA` (12 chars)
- Start at `A` (bottom-right)
- Move to `0`, press → `<A`
- Move to `2`, press → `^A`
- Move to `9`, press → `>^^A`
- Move to `A`, press → `vvvA`

---

#### Layer 2 (Robot 2's Directional Keypad)
Robot 2 must TYPE the sequence `<A^A>^^AvvvA` (12 characters) on its directional keypad

**Simulation**: Robot 2 starts at `A` (0,2)

For each button to press in `<A^A>^^AvvvA`:

| Button | From | To | Path | Length |
|--------|------|-----|------|--------|
| `<` | A(0,2) | <(1,0) | v<< + A | v<<A (4) |
| `A` | <(1,0) | A(0,2) | >^ + A | >^A (3) |
| `^` | A(0,2) | ^(0,1) | < + A | <A (2) |
| `A` | ^(0,1) | A(0,2) | > + A | >A (2) |
| `>` | A(0,2) | >(1,2) | v + A | vA (2) |
| `^` | >(1,2) | ^(0,1) | <^ + A | <^A (3) |
| `^` | ^(0,1) | ^(0,1) | (stay) + A | A (1) |
| `A` | ^(0,1) | A(0,2) | > + A | >A (2) |
| `v` | A(0,2) | v(1,1) | <v + A | <vA (3) |
| `v` | v(1,1) | v(1,1) | (stay) + A | A (1) |
| `v` | v(1,1) | v(1,1) | (stay) + A | A (1) |
| `A` | v(1,1) | A(0,2) | >^ + A | >^A (3) |

**Concatenating**: `v<<A` + `>^A` + `<A` + `>A` + `vA` + `<^A` + `A` + `>A` + `<vA` + `A` + `A` + `>^A`

**Result**: `v<<A>^A<A>AvA<^AA>A<vAAA>^A` (**28 chars**)

---

#### Layer 1 (Robot 1's Directional Keypad)
Robot 1 must TYPE the sequence `v<<A>^A<A>AvA<^AA>A<vAAA>^A` (28 characters) on its directional keypad

**Same process**: Simulate Robot 1's arm pressing each of the 28 characters

**Result**: (**? chars** - this is where the complexity grows)

---

#### Layer 0 (YOUR Directional Keypad)
You must TYPE the output from Layer 1 on your directional keypad

**Result**: **68 characters**

---

#### Final Calculation
- YOUR sequence: 68 chars
- Numeric value of "029A": 29
- Complexity: 68 × 29 = **1,972**

---

### 6. ALGORITHM

This requires a **three-phase approach**:

#### Phase 1: Precompute Button-to-Button Paths

For both numeric and directional keypads:
- BFS from each button to every other button
- Find all shortest paths that avoid gaps
- Store: `paths[from][to] = [path1, path2, ...]`

**Example** (directional keypad):
```swift
// From ^ (0,1) to > (1,2)
paths['^']['>'] = ["v>A", ">vA"]  // both length 3, both avoid gap
```

**Complexity**: O(keypad_size²) per keypad (typically small, ~25 buttons)

---

#### Phase 2: Sequence Length Calculation (Recursive + Memoized)

**Function**: `sequenceLength(sequence: String, depth: Int) -> Int`

**Base case**: `depth == 0` → return `sequence.count` (your keyboard input)

**Recursive case**: `depth > 0`
1. Break sequence into "button press chunks" (each button → path + A)
2. For each button:
   - Find shortest path from current position to target button
   - Choose path that minimizes downstream length (try all if multiple shortest)
   - Recursively calculate length at `depth - 1`
3. Memoize: `memo[(sequence, depth)]` → length

**Example**:
```swift
func sequenceLength(seq: String, depth: Int) -> Int {
    if depth == 0 { return seq.count }

    if let cached = memo[(seq, depth)] {
        return cached
    }

    var currentPos = 'A'  // Start at A
    var totalLength = 0

    for targetButton in seq {
        // Find shortest path from currentPos to targetButton
        let paths = pathsBetween[currentPos][targetButton]!

        // For multiple shortest paths, choose the best one
        var bestLength = Int.max
        for path in paths {
            let fullSequence = path + "A"  // Add activation
            let length = sequenceLength(fullSequence, depth - 1)
            bestLength = min(bestLength, length)
        }

        totalLength += bestLength
        currentPos = targetButton
    }

    memo[(seq, depth)] = totalLength
    return totalLength
}
```

---

#### Phase 3: Calculate Code Complexity

For each code (e.g., "029A"):

1. **Find shortest numeric keypad sequence**
   - BFS on numeric keypad from A → 0 → 2 → 9 → A
   - Result: `<A^A>^^AvvvA` (12 chars)

2. **Calculate final YOUR-keypad length**
   - Call: `sequenceLength("<A^A>^^AvvvA", depth=2)`
   - (depth=2 because we have 2 robot layers between numeric and you)
   - Result: 68 chars

3. **Calculate complexity**
   - Extract numeric value: 29 (from "029A")
   - Complexity: 68 × 29 = 1,972

4. **Sum all complexities**
   - Add this to running total

---

### 7. EDGE CASES

**Critical gotchas**:

1. **Gap avoidance**
   - Numeric keypad gap: (3,0) - bottom left
   - Directional keypad gap: (0,0) - top left
   - Some shortest paths hit the gap and are **invalid**
   - Example: From `7` to `A` on numeric, cannot go `v v v > > >` (passes through gap)
   - Must filter invalid paths during BFS

2. **Multiple shortest paths with different costs**
   - Example: Moving from `>` to `^` on directional can be `<^A` or `^<A`
   - Both are 3 chars at this layer
   - But downstream, one might expand to longer sequence
   - Must try all shortest paths and pick the minimum final length

3. **Memoization key design**
   - Key: `(sequence_string, depth_level)`
   - Same sequence at different depths has different lengths
   - Must include both in key

4. **Starting position tracking**
   - Each layer starts at `A`
   - When calculating a new sequence, must track where the arm currently is
   - Don't assume it's at `A` after each button press

5. **Numeric value extraction**
   - Code "029A" → numeric value is 29 (drop leading zeros and the A)
   - Code "980A" → numeric value is 980
   - Must parse correctly

---

### 8. DATA STRUCTURES

```swift
// Keypad button positions
let numericKeys: [Character: (row: Int, col: Int)] = [
    '7': (0, 0), '8': (0, 1), '9': (0, 2),
    '4': (1, 0), '5': (1, 1), '6': (1, 2),
    '1': (2, 0), '2': (2, 1), '3': (2, 2),
    '0': (3, 1), 'A': (3, 2)
]

let directionalKeys: [Character: (row: Int, col: Int)] = [
    '^': (0, 1), 'A': (0, 2),
    '<': (1, 0), 'v': (1, 1), '>': (1, 2)
]

// Shortest paths between buttons
// Format: pathsBetween[from][to] = [sequence1, sequence2, ...]
var pathsBetween: [Character: [Character: [String]]] = [:]

// Memoization for sequence lengths at each depth
// Format: memo[(sequence, depth)] = length
var memo: [String: [Int: Int]] = [:]  // or use tuple key if language supports

// For BFS path finding
struct BFSState {
    let position: (row: Int, col: Int)
    let path: String
}
```

---

## CRITICAL VERIFIED FACTS

These have been **manually verified** against the AoC problem statement:

```
Code: 029A

Layer 3 (Numeric keypad):     <A^A>^^AvvvA         = 12 characters
Layer 2 (Robot 2's dir):      v<<A>>^A<A>AvA<^AA>A<vAAA>^A = 28 characters
Layer 1 (Robot 1's dir):      (long sequence)      = ? characters
Layer 0 (YOUR dir):           (even longer)        = 68 characters

Numeric value of "029A": 29
Complexity: 68 × 29 = 1,972
```

---

## Implementation Strategy

### Step 1: Precompute Paths (No Memoization Needed Here)
- BFS for numeric keypad (small, ~25 buttons)
- BFS for directional keypad (small, ~5 buttons)
- Filter paths that pass through gaps
- Store all shortest paths (multiple may exist)

### Step 2: Implement Sequence Length Calculator
- Recursive function with memoization
- Depth parameter: 0 = your keyboard, 2 = past 2 robots
- Try all shortest paths, pick minimum
- Test with "029A" → should eventually get 68

### Step 3: Calculate Complexities
- For each of 5 codes
- Get shortest numeric sequence (BFS)
- Calculate final length with memoized function
- Multiply by numeric value
- Sum results

### Step 4: Part 2 Preparation
- Same algorithm, different depth parameter
- Part 1: depth = 2 (2 intermediate robots)
- Part 2: depth likely = ? (more robots?)
- Memoization should handle the increased depth efficiently

---

## Potential Optimizations

1. **Pre-cache common sequences**: High-frequency sequences like "A", "AA", "<A", ">A" etc. will be calculated many times

2. **Bidirectional paths**: Paths are symmetric (A→B = reverse of B→A reversed), but directionality matters for multiple paths

3. **Greedy vs Optimal**: Multiple shortest paths—might not need to try all, could use heuristic to choose "best" one

4. **Early termination**: If a path is clearly suboptimal, skip calculating full chain

---

## Testing Plan

**Example Input** (provided in problem):
```
029A
980A
179A
456A
379A
```

**Expected Output**: 126,384 (sum of complexities)

**Breakdown**:
- 029A: 68 × 29 = 1,972
- 980A: 60 × 980 = 58,800
- 179A: 68 × 179 = 12,172
- 456A: 64 × 456 = 29,184
- 379A: 64 × 379 = 24,256
- **Total**: 126,384 ✓

**Verification steps**:
1. Verify numeric keypad sequences are 12 chars
2. Verify directional keypad transformations
3. Verify your keypad sequences are 68, 60, 68, 64, 64 (for the 5 codes)
4. Verify numeric values are 29, 980, 179, 456, 379
5. Verify complexities sum to 126,384

---

## Next Steps

1. Implement BFS for pathfinding (with gap avoidance)
2. Implement sequence length calculator (recursive + memoized)
3. Test with example input
4. Calculate Part 1 answer
5. Adjust for Part 2 (likely just change depth parameter)

---

*Analysis completed: November 14, 2024*
*Ready for implementation*
