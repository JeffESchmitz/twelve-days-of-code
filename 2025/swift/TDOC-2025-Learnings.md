# Twelve Days of Code 2025 - Learning Summary

Quick reference guide for concepts learned during the 2025 challenge.

---

## Day 01: Secret Entrance

**Puzzle**: Circular dial rotation (0-99), count zero crossings
**Solutions**: Part 1: 1145, Part 2: 6561

### Key Concepts

**Modular Arithmetic for Circular Wrapping**
```swift
position = ((position % 100) + 100) % 100
```
- Handles both positive and negative wraparound
- O(1) complexity regardless of rotation size

**Zero-Crossing Calculation**
- LEFT: `distanceToZero = position`
- RIGHT: `distanceToZero = 100 - position`
- Formula: `1 + (distance - distanceToZero) / 100`

### Pattern: Simulation

```swift
var state = initialState
for instruction in instructions {
    state = transform(state, instruction)
    if condition(state) {
        count += 1
    }
}
```

### Debugging Lessons

- If-statements for wraparound only handle single wrap
- Always test with large edge case values
- Mathematical optimization > brute force simulation

### Swift Techniques

- Data modeling: `struct Rotation`
- Input parsing: `split()` + `compactMap()`
- Helper functions for complex logic

**Related patterns**: Clock arithmetic, circular buffers, hash table probing

**Detail**: See `Sources/Day01-learnings.md`

---

## Day 02: Gift Shop

**Puzzle**: Pattern detection in product IDs (repeated digit sequences)
**Solutions**: Part 1: 24043483400, Part 2: 38262920235

### Key Concepts

**Arithmetic Pattern Detection (No String Conversion)**
```swift
// Extract last k digits
let pattern = number % POW10[k]

// Extract first k digits
let upperHalf = number / POW10[k]

// Reconstruct by repeating
reconstructed = reconstructed * divisor + pattern
```

**Performance Optimization**
- Precompute powers of 10: `POW10[i]` for O(1) lookup
- Avoid string conversion for digit manipulation

**Leading Zero Detection**
```swift
// Pattern must have correct digit count
guard pattern >= POW10[patternLength - 1] else { continue }
```

### Pattern: Performance-Aware Functional Programming

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

**Never Use .lazy in Hot Paths** ⚠️:
- `.lazy` was 25x SLOWER (1567ms vs 63ms)
- Closure overhead on every element access
- Only use for infinite sequences or massive datasets

### Refactoring Lessons

**Scientific Method**:
1. Establish baseline (62.8ms)
2. One change at a time
3. Benchmark after each step
4. Revert if >20% regression

**Outcome**:
- ✅ part1/part2: Functional (12% faster)
- ❌ isRepeatedAtLeastTwice: Reverted to manual loops (21% faster)

**Rule of Thumb**:
- Outer loops with large data → Functional
- Inner loops called millions of times → Manual

### Swift Techniques

- Precomputation with lazy globals
- Range flattening: `.flatMap { $0.start...$0.end }`
- AoCTools `.sum()` for clean pipelines
- Guard-heavy validation pattern

**Related patterns**: Digit manipulation, pattern detection, performance profiling

**Detail**: See `Sources/Day02-learnings.md`

---

## Day 03: TBD

...

---

## Summary of Patterns

### Algorithms Used
- [ ] BFS/DFS
- [ ] Dynamic Programming
- [ ] Greedy
- [x] Simulation
- [ ] Backtracking
- [ ] Binary Search
- [ ] Graph Theory
- [x] Pattern Detection

### Data Structures Used
- [x] Structs
- [x] Arrays/Sequences
- [ ] Sets
- [ ] Dictionaries
- [ ] Queues/Stacks
- [ ] Graphs
- [ ] Trees

### Swift Features Used
- [x] Parsing with split/compactMap
- [ ] Swift Parsing library
- [ ] Pattern matching
- [x] Sequence protocols (flatMap/filter)
- [ ] Collections library
- [x] Async/await
- [x] Lazy globals for precomputation
- [x] Performance profiling

---

## Quick Reference

### Common Swift Patterns

**Parse lines**:
```swift
input.split(separator: "\n").compactMap { line in
    // Parse line
}
```

**Modulo wrap**:
```swift
value = ((value % max) + max) % max
```

**Count occurrences**:
```swift
items.reduce(into: [:]) { $0[$1, default: 0] += 1 }
```

**Digit extraction (arithmetic)**:
```swift
let lastKDigits = number % POW10[k]
let firstKDigits = number / POW10[k]
```

**Precompute expensive calculations**:
```swift
private let POW10: [Int] = {
    var powers = [Int](repeating: 1, count: 19)
    for i in 1..<powers.count {
        powers[i] = powers[i - 1] * 10
    }
    return powers
}()
```

**Functional pipeline**:
```swift
items
    .flatMap { ... }
    .filter { ... }
    .sum()  // from AoCTools
```

---

**Challenge Period**: December 1-12, 2025
**Completion Status**: 2/12 days complete ⭐⭐⭐⭐
