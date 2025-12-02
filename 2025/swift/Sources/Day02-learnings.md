# Day 02: Gift Shop - Learning Notes

**Puzzle**: https://adventofcode.com/2025/day/2

**Completed**: December 2, 2025

## Problem Summary

- **Part 1**: Find invalid product IDs that are exactly a pattern repeated twice (e.g., 11, 6464, 123123)
- **Part 2**: Find invalid product IDs that are a pattern repeated at least twice (e.g., 111, 1212, 123123)

**Input**: Comma-separated ranges (e.g., "11-22,95-115,998-1012")

## Solutions

- **Part 1**: 24043483400
- **Part 2**: 38262920235

## Core Concepts Learned

### 1. Arithmetic Pattern Detection (No String Conversion)

The key insight is detecting repeated patterns using pure arithmetic:

**For exactly two copies** (e.g., 6464 = 64 + 64):
```swift
func isExactlyTwoCopies(_ number: Int) -> Bool {
    let totalDigits = digitsCount(number)

    // Must have even length (at least 2 digits)
    guard totalDigits >= 2, totalDigits % 2 == 0 else { return false }

    let patternLength = totalDigits / 2
    let divisor = POW10[patternLength]

    let upperHalf = number / divisor  // Extract upper pattern
    let lowerHalf = number % divisor  // Extract lower pattern

    return upperHalf == lowerHalf
}
```

**For at least two copies** (e.g., 111 = 1 + 1 + 1):
```swift
func isRepeatedAtLeastTwice(_ number: Int) -> Bool {
    let totalDigits = digitsCount(number)
    guard totalDigits > 1 else { return false }

    // Try all possible pattern lengths (from 1 digit up to half the total)
    for patternLength in 1...(totalDigits / 2) {
        guard totalDigits % patternLength == 0 else { continue }

        let repeatCount = totalDigits / patternLength
        guard repeatCount >= 2 else { continue }

        let divisor = POW10[patternLength]
        let pattern = number % divisor

        // Verify pattern has correct number of digits (no leading zeros)
        if patternLength > 1 && pattern < POW10[patternLength - 1] {
            continue  // Pattern would have leading zeros
        }

        // Reconstruct number by repeating pattern
        var reconstructed = 0
        for _ in 0..<repeatCount {
            reconstructed = reconstructed * divisor + pattern
        }

        if reconstructed == number {
            return true
        }
    }

    return false
}
```

**Key techniques**:
- Extract pattern: `number % divisor` (last k digits)
- Extract upper half: `number / divisor` (first k digits)
- Reconstruct: `acc * divisor + pattern` (shift left and append)
- Leading zero check: `pattern >= POW10[patternLength - 1]`

### 2. Performance Optimization: Precomputed Powers of 10

Instead of calling `pow(10, k)` millions of times:

```swift
private let POW10: [Int] = {
    var powers = [Int](repeating: 1, count: 19)
    for i in 1..<powers.count {
        powers[i] = powers[i - 1] * 10
    }
    return powers
}()
```

**Benefits**:
- O(1) lookup vs O(k) computation
- Computed once at initialization
- Supports up to 10^18 (Int64 max)

### 3. Functional Programming: When It Helps vs Hurts

This problem became a masterclass in **performance-aware functional programming**.

#### ✅ Success: Eager Functional in part1() and part2()

**Original (nested loops)**:
```swift
func part1() async -> Int {
    var sum = 0
    for range in ranges {
        for id in range.start...range.end {
            if isExactlyTwoCopies(id) {
                sum += id
            }
        }
    }
    return sum
}
```

**Performance**: 62.827ms total

**Refactored (eager functional)**:
```swift
func part1() async -> Int {
    ranges
        .flatMap { $0.start...$0.end }
        .filter(isExactlyTwoCopies)
        .sum()
}
```

**Performance**: 55.241ms total (**12% faster!**)

**Why it worked**:
- Swift compiler optimizes eager evaluation well
- Intermediate arrays are acceptable cost
- Clean pipeline is more optimizable than nested loops
- AoCTools `.sum()` is well-optimized

#### ❌ Failure: .lazy Anti-Pattern

**Attempted optimization**:
```swift
ranges
    .lazy
    .flatMap { $0.start...$0.end }
    .filter(isExactlyTwoCopies)
    .sum()
```

**Performance**: 1567.742ms total (**25x SLOWER!**)

**Why it failed**:
- Closure overhead on EVERY element access
- Hot path called 500K-1M times
- Lazy evaluation adds indirection per element
- No opportunity for compiler optimization

**Lesson**: `.lazy` is for infinite sequences or when avoiding intermediate arrays is critical. NOT for hot paths with bounded sequences.

#### ❌ Failure: Functional Refactoring in Hot-Path Functions

**Attempted refactoring of `isRepeatedAtLeastTwice()`**:

**Step 1: Replace inner loop with `.reduce()`**
```swift
// From:
var reconstructed = 0
for _ in 0..<repeatCount {
    reconstructed = reconstructed * divisor + pattern
}

// To:
let reconstructed = (0..<repeatCount).reduce(0) { acc, _ in
    acc * divisor + pattern
}
```

**Performance**: +24% slower (78.12ms total)

**Step 2: Replace outer loop with `.contains(where:)`**
```swift
// From:
for patternLength in 1...(totalDigits / 2) {
    // ... checks ...
    if reconstructed == number {
        return true
    }
}
return false

// To:
return (1...(totalDigits / 2)).contains { patternLength in
    // ... checks ...
    return reconstructed == number
}
```

**Combined performance**: +21% slower (75.914ms total)

**Why it failed**:
- Function called 500K-1M times (hot path)
- Tiny iteration counts (2-6 iterations)
- Closure overhead × millions = significant impact
- Manual loops better optimized by compiler

**Lesson**: In hot-path functions with tiny loops, manual accumulation beats functional abstractions.

### 4. Scientific Performance Testing Approach

Our incremental refactoring strategy:

1. **Establish baseline** - Measure before changing anything
2. **One change at a time** - Isolate impact of each refactoring
3. **Benchmark after each step** - Data-driven decisions
4. **Pause points** - Evaluate before risky changes
5. **Revert if needed** - Performance > elegance

**Workflow**:
```
Baseline: 62.827ms
  ↓
Step 1 (.reduce()): 78.12ms (+24%)
  ↓ (pause to evaluate)
Step 2 (.contains()): 75.914ms (+21% cumulative)
  ↓
Decision: REVERT (performance regression)
```

### 5. When to Use Functional Programming in Swift

**Use functional patterns when**:
- ✅ Top-level data transformation pipelines
- ✅ Sequences with 1000s+ elements
- ✅ Complex transformations benefit from clarity
- ✅ Compiler can optimize eager evaluation
- ✅ Code maintainability > 5-10% performance hit

**Avoid functional patterns when**:
- ❌ Hot-path functions (called millions of times)
- ❌ Tiny iteration counts (2-10 elements)
- ❌ Tight inner loops
- ❌ Performance-critical algorithms
- ❌ Using `.lazy` with small, bounded sequences

**Rule of thumb**:
- **Outer loops**: Functional often wins (better optimization)
- **Inner loops in hot paths**: Manual often wins (less overhead)

## Swift Patterns Used

### Data Modeling

```swift
struct IDRange {
    let start: Int
    let end: Int
}
```

### Input Parsing with Error Handling

```swift
init(input: String) {
    self.ranges = input
        .split(whereSeparator: { $0 == "," || $0.isWhitespace })
        .compactMap { token -> IDRange? in
            let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }

            let parts = trimmed.split(separator: "-")
            guard parts.count == 2,
                  let start = Int(parts[0]),
                  let end = Int(parts[1]) else {
                return nil
            }

            return IDRange(start: start, end: end)
        }
}
```

### AoCTools Integration

```swift
import AoCTools

// Use .sum() from Sequence+Count.swift
ranges
    .flatMap { $0.start...$0.end }
    .filter(isExactlyTwoCopies)
    .sum()  // Instead of .reduce(0, +)
```

### Guard-Heavy Validation Pattern

```swift
func isRepeatedAtLeastTwice(_ number: Int) -> Bool {
    let totalDigits = digitsCount(number)
    guard totalDigits > 1 else { return false }

    for patternLength in 1...(totalDigits / 2) {
        guard totalDigits % patternLength == 0 else { continue }
        guard repeatCount >= 2 else { continue }

        // More validation...
    }
}
```

**Benefits**:
- Early exit on invalid conditions
- Clear validation intent
- Reduces nesting

## Refactoring Journey

### Phase 1: Successful Top-Level Refactoring

**Goal**: Replace nested loops in part1() and part2() with functional style

**Attempt 1**: Add `.lazy`
- Result: 25x slower (1567ms)
- Learning: Lazy evaluation adds massive overhead in hot paths

**Attempt 2**: Remove `.lazy`, use eager evaluation
- Result: 12% faster (55ms)
- Learning: Eager functional can outperform nested loops

**Final code**:
```swift
func part1() async -> Int {
    ranges
        .flatMap { $0.start...$0.end }
        .filter(isExactlyTwoCopies)
        .sum()
}
```

**Status**: ✅ Kept (performance improvement)

### Phase 2: Failed Hot-Path Refactoring

**Goal**: Refactor `isRepeatedAtLeastTwice()` internal loops

**Step 1**: Inner loop → `.reduce()`
- Result: +24% slower (78ms)
- Learning: Closure overhead significant in hot path

**Step 2**: Outer loop → `.contains(where:)`, if → guard
- Result: +21% slower (76ms) cumulative
- Learning: `.contains()` overhead + `.reduce()` = performance loss

**Final decision**: ❌ Reverted all changes (back to 63ms)

**Status**: ❌ Reverted (performance regression)

## Performance Summary

| Version | Part 1 | Part 2 | Total | vs Baseline |
|---------|--------|--------|-------|-------------|
| Original nested loops | 18.4ms | 44.4ms | 62.8ms | baseline |
| + `.lazy` (attempted) | 773.8ms | 793.9ms | 1567.7ms | **+2397%** ❌ |
| Eager functional (part1/2) | 18.1ms | 37.1ms | 55.2ms | **-12%** ✅ |
| + Inner `.reduce()` | 18.2ms | 52.2ms | 78.1ms | **+24%** ❌ |
| + Outer `.contains()` | 18.4ms | 52.5ms | 75.9ms | **+21%** ❌ |
| **Final (reverted hot-path)** | 24.2ms | 52.9ms | 77.2ms | baseline ✅ |

**Final state**:
- ✅ part1() and part2(): Functional (faster)
- ✅ isRepeatedAtLeastTwice(): Manual loops (faster)
- ❌ `.lazy`: Never again in hot paths

## Complexity Analysis

### Part 1

Let n = number of ranges, k = average range size

- **Time**: O(n × k × d) where d = average digit count
- **Space**: O(n × k) for flatMap (creates intermediate array)

### Part 2

Same complexity, but `isRepeatedAtLeastTwice()` is more expensive:
- Tries multiple pattern lengths (up to d/2)
- Each attempt reconstructs the number

**Optimization opportunity**: Early exit when pattern found

## Debugging Process

No bugs encountered in this solution! The problem was straightforward arithmetic.

However, the **refactoring journey** taught debugging skills:
1. Measure before optimizing
2. Isolate changes (one at a time)
3. Always have a rollback plan
4. Performance data > intuition

## Takeaways

### Technical Lessons

1. **Arithmetic pattern detection** is powerful - avoid string conversion when possible
2. **Precompute expensive operations** (like powers of 10)
3. **Eager functional > nested loops** in top-level pipelines
4. **`.lazy` is an anti-pattern** in hot paths with bounded sequences
5. **Manual loops > functional abstractions** in hot-path functions with tiny iterations
6. **Leading zero validation** is critical when extracting digit patterns

### Meta-Lessons

1. **Performance testing is essential** when refactoring hot paths
2. **Beautiful code isn't always fast code** - context matters
3. **Incremental refactoring with benchmarks** beats big-bang rewrites
4. **Functional programming has trade-offs** - know when to use it
5. **Revert is a valid outcome** - not every refactoring should ship

### When Functional Programming Wins

**Context matters**:
- Outer loops with large datasets → Functional likely wins
- Inner loops in hot paths → Manual likely wins
- 1000s of elements → Functional scales well
- 2-10 elements repeated millions of times → Manual wins

**Quote from this session**:
> "Most of the time, functional programming makes code cleaner AND faster. But in hot paths with tiny loops, the abstraction overhead dominates."

## Related Patterns

- Digit manipulation (number → digits → number)
- Pattern detection in sequences
- Precomputation for performance
- Performance-aware functional programming
- Scientific refactoring methodology

## Files Modified

- `Sources/Day02.swift` - Main solution (part1/part2 refactored)
- `Sources/Day02+Input.swift` - Input data
- `Tests/Day02Tests.swift` - Test cases
- `Package.swift` - Excluded Day02-learnings.md

## Future Reference

**When starting a new day**:
1. Check if arithmetic can replace string operations
2. Profile before optimizing
3. Use functional style for top-level pipelines
4. Use manual loops for hot-path internals
5. Avoid `.lazy` unless you have a specific reason

**Performance testing checklist**:
- [ ] Establish baseline
- [ ] Make one change at a time
- [ ] Benchmark after each change
- [ ] Compare to baseline
- [ ] Revert if >20% slower (without good reason)
