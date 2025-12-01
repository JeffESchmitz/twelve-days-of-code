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

## Day 02: TBD

...

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

### Data Structures Used
- [x] Structs
- [ ] Arrays/Sequences
- [ ] Sets
- [ ] Dictionaries
- [ ] Queues/Stacks
- [ ] Graphs
- [ ] Trees

### Swift Features Used
- [x] Parsing with split/compactMap
- [ ] Swift Parsing library
- [ ] Pattern matching
- [ ] Sequence protocols
- [ ] Collections library
- [ ] Async/await

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

---

**Challenge Period**: December 1-12, 2025
**Completion Status**: 1/12 days complete ⭐⭐
