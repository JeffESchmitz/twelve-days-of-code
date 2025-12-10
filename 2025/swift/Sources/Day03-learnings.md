# Day 03: Lobby - Learning Notes

**Puzzle**: https://adventofcode.com/2025/day/3

**Completed**: December 3, 2025

## Problem Summary

- **Part 1**: Select 2 batteries from each bank to form a 2-digit number, maximize joltage
- **Part 2**: Select 12 batteries from each bank to form a 12-digit number, maximize joltage

**Constraint**: Must preserve positional order (if picking position `i` first, can only pick `j` where `j > i`)

**Input**: Lines of digit strings representing battery banks

## Solutions

- **Part 1**: 17613
- **Part 2**: 175304218462560

## Core Concepts Learned

### 1. Positional Constraint Changes Algorithm Selection

The "in order" constraint fundamentally determines algorithm choice:
- Cannot rearrange digits - order must be preserved
- If picking position `i` first, can only pick position `j` where `j > i`

This transforms a simple "pick max digits" problem into an algorithmic challenge.

### 2. Part 1: Suffix Maximum (One-Pass Optimization)

**Insight**: For each position as tens digit, pair with maximum from remaining positions.

```swift
private func maxJoltage(_ bank: [Int]) -> Int {
    guard bank.count >= 2 else { return 0 }

    var maxJoltage = 0
    var maxSoFar = bank[bank.count - 1]  // Start with rightmost

    // Scan backwards from second-to-last to first
    for i in stride(from: bank.count - 2, through: 0, by: -1) {
        let joltage = bank[i] * 10 + maxSoFar
        maxJoltage = max(maxJoltage, joltage)
        maxSoFar = max(maxSoFar, bank[i])
    }

    return maxJoltage
}
```

**Why backwards scan?**
- At position `i`, we need max of `bank[i+1...]`
- By scanning backwards, we maintain `maxSoFar` as running maximum
- Single pass: O(n) time, O(1) space

**Complexity comparison**:
- Naive (try all pairs): O(n²)
- Suffix precomputation array: O(n) time, O(n) space
- Running maximum (chosen): O(n) time, O(1) space

### 3. Part 2: Monotonic Stack (Remove K Digits)

**Classic algorithm**: Given n digits, remove (n-k) to maximize remaining k-digit number.

```swift
private func maxJoltageKDigits(_ bank: [Int], keep: Int) -> Int {
    let n = bank.count
    guard n > keep else {
        return bank.reduce(0) { $0 * 10 + $1 }
    }

    var skip = n - keep  // Number to remove
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

    return stack.reduce(0) { $0 * 10 + $1 }
}
```

**Key insight**: Greedily prefer larger digits in earlier positions.

**Stack invariant**: At any point, stack contains digits that could be in the final answer.

**Three scenarios**:
1. Current > stack.last → Pop smaller digits (they're in worse positions)
2. Current ≤ stack.last → Push (keep for now)
3. Out of skips → Must keep everything remaining

### 4. Swift `stride()` for Backwards Iteration

```swift
// Both are equivalent:
stride(from: count - 2, through: 0, by: -1)  // Includes 0
stride(from: count - 2, to: -1, by: -1)      // Also includes 0

// Alternative using reversed():
(0...count - 2).reversed()
```

**Preference**: `stride` is clearer for backwards iteration with explicit bounds.

### 5. Integer Reconstruction from Digits

```swift
// Convert [1, 2, 3] to 123
digits.reduce(0) { $0 * 10 + $1 }

// Step by step:
// 0 * 10 + 1 = 1
// 1 * 10 + 2 = 12
// 12 * 10 + 3 = 123
```

This is the inverse of digit extraction and works for any number of digits.

## Swift Patterns Used

### Digit Parsing from Characters

```swift
// Convert character string to digit array
line.compactMap { $0.wholeNumberValue }
// "12345" → [1, 2, 3, 4, 5]
```

### Guard for Edge Cases

```swift
guard bank.count >= 2 else { return 0 }
guard n > keep else {
    return bank.reduce(0) { $0 * 10 + $1 }
}
```

### Functional Pipeline for Aggregation

```swift
func part1() async -> Int {
    banks
        .map(maxJoltage)
        .sum()
}
```

## Algorithm Selection by Problem Structure

| Problem Type | Algorithm | Time | Space |
|--------------|-----------|------|-------|
| Pick 2, maximize pairing | Suffix maximum | O(n) | O(1) |
| Pick k, maximize number | Monotonic stack | O(n) | O(k) |
| Pick k, any order allowed | Sort + take top k | O(n log n) | O(1) |

**Key lesson**: The "in order" constraint makes this harder than simple selection.

## Performance

- Part 1: 1.3ms (O(n) per bank, 197 banks)
- Part 2: 8.0ms (O(n) per bank with stack operations)
- Total: 9.3ms

## Debugging Process

Used Socratic method to discover the solution:
1. Started with questions about constraints
2. Discovered "in order" rule through example analysis
3. Identified that Part 1 and Part 2 need different algorithms
4. Recognized Part 2 as classic "Remove K Digits" problem

## Takeaways

1. **Read constraints carefully** - "in order" completely changes the algorithm
2. **Running maximum** is powerful for "best from remaining" queries
3. **Monotonic stack** is the go-to for digit selection problems
4. **Same problem domain ≠ same algorithm** - Part 1 vs Part 2 need different approaches
5. **Backwards iteration** often simplifies "suffix" queries

## Related Patterns

- Greedy algorithms
- Monotonic stack/queue
- Suffix array optimizations
- "Remove K Elements" variants
- LeetCode 402: Remove K Digits (identical to Part 2)

## Files Modified

- `Sources/Day03.swift` - Main solution
- `Sources/Day03+Input.swift` - Input data
- `Tests/Day03Tests.swift` - Test cases
