# Day 10: Factory - Learnings

## The Challenge

**Part 1**: Buttons TOGGLE indicator lights (XOR). Find minimum button presses to reach target light pattern.
**Part 2**: Buttons INCREMENT counters. Find minimum total button presses to reach joltage targets.

This was the hardest puzzle of 2025 so far - a true "mind bender" as warned!

---

## Part 1: BFS Over Bitmask States (Easy)

Standard BFS with state represented as bitmask:

```swift
// State = which lights are ON (bit i = 1 if light i is on)
let target = pattern.enumerated().reduce(0) { acc, pair in
    pair.element ? acc | (1 << pair.offset) : acc
}

// Each button press XORs a mask
let buttonMasks = buttons.map { button in
    button.reduce(0) { $0 | (1 << $1) }
}

// BFS from state 0 to target
var queue = Deque<(state: Int, presses: Int)>([(0, 0)])
while let (state, presses) = queue.popFirst() {
    for mask in buttonMasks {
        let newState = state ^ mask  // XOR toggle
        if newState == target { return presses + 1 }
        // ... standard BFS
    }
}
```

**Key insight**: XOR is its own inverse, so pressing a button twice = no change.

---

## Part 2: Integer Linear Programming (Hard!)

### The Problem Formulation

This is a classic **Integer Linear Programming (ILP)** problem:
- **Ax = b** where A is a 0/1 matrix (counter i affected by button j)
- **Minimize sum(x)** subject to x >= 0, x integer

### What We Tried (And Why It Failed)

#### Attempt 1: BFS Over Counter States
**Result**: Too slow for large joltage values (100-300)

The state space explodes when targets are large.

#### Attempt 2: Gaussian Elimination with Floating Point
**Result**: Precision errors caused incorrect -1 results

```swift
// WRONG - floating point precision issues
var matrix: [[Double]] = ...
```

#### Attempt 3: Rational Arithmetic
**Result**: Correct elimination, but search over free variables failed

Used `(numerator, denominator)` tuples with GCD reduction:
```swift
func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? abs(a) : gcd(b, a % b) }
func reduce(_ r: (Int, Int)) -> (Int, Int) { ... }
```

#### Attempt 4: Dynamic Bounds Computation
**Result**: Bounds computation was BROKEN for coupled constraints

**The bug**: When constraints are coupled (slanted edges in the feasible polytope), computing independent bounds for each variable produces incorrect or contradictory ranges:
```
Variable x9: lb=29, ub=31 (from independent analysis)
But with x12=15: Row 4 needs x10 >= 18, Row 8 needs x10 <= 15
These are INCOMPATIBLE - no solution exists in the computed bounds!
```

### The Breakthrough: Negative Cost Coefficients

**Gemini's key insight**: The "net cost" of a free variable can be NEGATIVE!

```swift
// NetCost = 1 (for the button itself) - sum(coefficients in pivot rows)
let netCost = 1.0 - sumOfCoefficients

// If NetCost < 0: INCREASING the free variable DECREASES total presses!
```

**Why this happens**: When you increase a free variable with negative coefficients in the reduced matrix, the pivot variables DECREASE by more than the free variable increases.

**Example from Machine 11**:
- Free variable x12 has coefficients like -21/5, -2 in pivot rows
- Increasing x12 by 1 might decrease pivot variables by 4+
- Net effect: total presses goes DOWN

### The Fix: Smart Grid Search

Instead of complex bounds computation:
1. **Calculate net cost** for each free variable
2. **Sort by net cost** (most negative first)
3. **Iterate in optimal order**:
   - Negative cost vars: large values first (descending)
   - Positive cost vars: small values first (ascending)
4. **Prune aggressively**: break when current sum exceeds best known

```swift
let strideOrder = info.netCost < 0
    ? Array(range.reversed())  // High to low for negative cost
    : Array(range)             // Low to high for positive cost

for val in strideOrder {
    if currentFreeSum + val >= bestTotal && info.netCost > 0 { break }
    // ... recursive search
}
```

---

## The Final Algorithm

```
1. Build augmented matrix [A | b] with rational arithmetic
2. Gaussian elimination to reduced row echelon form
3. Check for inconsistency (0 = nonzero row)
4. Identify free variables (columns without pivots)
5. If no free variables: unique solution, sum pivot values
6. Calculate net cost for each free variable
7. Sort free variables by net cost (most negative first)
8. Grid search with smart ordering and pruning
9. Return minimum total found
```

---

## Key Learnings

### 1. ILP is NP-Hard
No polynomial algorithm exists for general Integer Linear Programming. But for small numbers of free variables (2-4), exhaustive search is practical.

### 2. Gaussian Elimination Reduces Dimensionality
A 10x13 system (10 counters, 13 buttons) reduces to 3 free variables after elimination. This makes search tractable.

### 3. Coupled Constraints Break Independent Bounds
The "obvious" approach of computing lb/ub for each variable independently fails when constraints interact. The feasible region is a polytope, not a rectangular box.

### 4. Search Direction Matters
With negative cost coefficients, optimal solutions lie at the "far edge" of the feasible region, not near zero. Searching in the wrong direction wastes time exploring suboptimal solutions first.

### 5. Rational Arithmetic Avoids Precision Issues
Using (numerator, denominator) pairs with GCD reduction gives exact arithmetic. Essential when checking if results are integers.

### 6. Collaboration Unlocks Insights
This puzzle was solved through collaboration with Gemini, who identified the negative cost coefficient insight that unlocked the solution.

---

## Performance

| Metric | Before | After (Optimized) |
|--------|--------|-------------------|
| Part 1 | ~13ms | ~2ms |
| Part 2 | ~15 seconds | ~300ms |
| Machines | 158 | 158 |
| Free vars (typical) | 2-3 | 2-3 |
| Search space | ~3.4M states (worst case) | Same |

### Optimization Applied

1. **LCM Scaling**: Convert rational arithmetic to integer arithmetic during grid search
2. **Mutable Backtracking**: Single array with forward/restore instead of copying
3. **While Loops**: Avoid array allocations in hot loop
4. **Parallel Processing**: Use TaskGroup to process machines concurrently

**Speedup: ~50x** (15s → 300ms in release build)

---

## Mathematical Concepts Used

- **Linear Algebra**: Gaussian elimination, reduced row echelon form
- **Rational Arithmetic**: Exact computation without floating point
- **Integer Programming**: Non-negative integer solutions to linear systems
- **Optimization**: Minimizing objective function over feasible region
- **Complexity Analysis**: Understanding when brute force is practical

---

## Code Techniques

```swift
// Rational number representation
typealias Rational = (Int, Int)  // (numerator, denominator)

// Gaussian elimination with rational arithmetic
func div(_ a: Rational, _ b: Rational) -> Rational {
    reduce((a.0 * b.1, a.1 * b.0))
}

// Net cost calculation
let netCost = 1.0 - pivotRows.map { toDouble(matrix[row][freeCol]) }.sum()

// Smart iteration order based on cost sign
let order = netCost < 0 ? Array(range.reversed()) : Array(range)
```

---

## What Would Have Helped

1. **Recognizing ILP earlier** - Could have researched standard approaches
2. **Testing bounds computation** - Would have caught the coupled constraint bug
3. **Analyzing the objective function** - Would have discovered negative costs sooner
4. **Simpler search first** - Full grid search would have worked, just slower

---

## Answers

- **Part 1**: 409
- **Part 2**: 15489

**Submitted values that were wrong**:
- 13119 (too low) - 16+ machines returning -1
- 14332 (too low) - 9 machines returning -1

The failing machines all had solutions at "far edge" values that our broken bounds computation missed!

---

## Credits

Special thanks to **Gemini** for the breakthrough insight about negative cost coefficients and the refactored search algorithm. This was truly a collaborative solve!
