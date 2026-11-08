# Day 01: Secret Entrance - Learning Notes

**Puzzle**: https://adventofcode.com/2025/day/1

**Completed**: December 1, 2025

## Problem Summary

- **Part 1**: Count how many times a circular dial (0-99) lands exactly on position 0 after each rotation
- **Part 2**: Count how many times the dial crosses or lands on position 0 during all rotations

**Input**: List of rotation commands (e.g., "L68", "R30")

- Direction: L (left/counterclockwise) or R (right/clockwise)
- Distance: number of positions to move

**Starting position**: 50

## Solutions

- **Part 1**: 1145
- **Part 2**: 6561

## Core Concepts Learned

### 1. Modular Arithmetic for Circular Wrapping

The key formula for handling wraparound on a circular dial:

```swift
position = ((position % 100) + 100) % 100
```

**Why this works**:

- First `% 100`: Normalizes large positive numbers
- `+ 100`: Handles negative numbers by making them positive
- Second `% 100`: Final normalization to range [0, 99]

**Example**:

```swift
// Negative wrap: -18
((-18 % 100) + 100) % 100 = (-18 + 100) % 100 = 82

// Positive wrap: 150
((150 % 100) + 100) % 100 = (50 + 100) % 100 = 50

// Large negative: -250
((-250 % 100) + 100) % 100 = (-50 + 100) % 100 = 50
```

### 2. Algorithm Evolution: Make It Work → Make It Right

**First attempt** (if-statements):
```swift
if position < 0 {
    position += 100
} else if position > 99 {
    position -= 100
}
```

**Problem**: Only handles single wraparound

- Works for distance = 110 (wraps once)
- Fails for distance = 250 (wraps twice)

**Result**: Answer too low (519 vs 1145)

**Better solution** (modulo):

```swift
position = ((position % 100) + 100) % 100
```

**Insight**: Modulo handles infinite wrapping in O(1) time

### 3. Part 2: Counting Zero Crossings

Instead of simulating every position during rotation, calculate mathematically:

```swift
private func countZeroCrossings(start: Int, distance: Int, isLeft: Bool) -> Int {
    if distance == 0 { return 0 }

    if isLeft {
        // Going left: distance to 0 is our current position
        let distanceToZero = start

        if distanceToZero == 0 {
            // Already at 0, count full circles only
            return distance / 100
        } else if distance >= distanceToZero {
            // We reach 0, plus maybe more circles after
            return 1 + (distance - distanceToZero) / 100
        } else {
            // Don't reach 0
            return 0
        }
    } else {
        // Going right: distance to 0 is how far to wrap around
        let distanceToZero = 100 - start

        if distanceToZero == 100 {
            // Already at 0, count full circles only
            return distance / 100
        } else if distance >= distanceToZero {
            // We reach 0, plus maybe more circles after
            return 1 + (distance - distanceToZero) / 100
        } else {
            // Don't reach 0
            return 0
        }
    }
}
```

**Key insights**:

- **Right rotation**: Distance to next 0 = `100 - start`
- **Left rotation**: Distance to next 0 = `start`
- **Full circles**: `(distance - distanceToZero) / 100` gives additional 0 crossings
- **Complexity**: O(1) instead of O(k) simulation

### 4. Teaching Pattern Recognition

The solution uses symmetry:
- Both directions use the same formula: `1 + (distance - distanceToZero) / 100`
- Only difference is how `distanceToZero` is calculated
- This reveals the underlying mathematical structure

## Swift Patterns Used

### Data Modeling

```swift
struct Rotation {
    let direction: Character  // 'L' or 'R'
    let distance: Int
}
```

### Input Parsing

```swift
func parseInput() -> [Rotation] {
    return input
        .split(separator: "\n")
        .compactMap { line -> Rotation? in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return nil }

            let direction = trimmed.first!
            let distanceString = trimmed.dropFirst()
            guard let distance = Int(distanceString) else { return nil }

            return Rotation(direction: direction, distance: distance)
        }
}
```

### Simulation Pattern

```swift
var position = 50
var count = 0

for rotation in rotations {
    // Apply transformation
    position = updatePosition(position, rotation)

    // Check condition
    if position == 0 {
        count += 1
    }
}
```

## Debugging Process

1. **Initial implementation**: Used if-statements for wraparound
2. **Test with example**: Passed ✅
3. **Submit Part 1**: Too low (519) ❌
4. **Root cause**: If-statements only handle single wrap
5. **Fix**: Switch to modulo arithmetic
6. **Retest**: 1145 ✅

**Lesson**: Always test with edge cases (large rotations)

## Complexity Analysis

### Part 1

- **Time**: O(n) where n = number of rotations
- **Space**: O(n) for storing parsed rotations

### Part 2

- **Time**: O(n) where n = number of rotations
- **Space**: O(n) for storing parsed rotations

Using mathematical calculation (O(1) per rotation) instead of simulation (O(k) per rotation where k = distance).

## Takeaways

1. **Modular arithmetic** is essential for circular/cyclic problems
2. **Simple if-statements** work until they don't - test edge cases
3. **Mathematical optimization** can replace simulation
4. **Symmetry in code** often reveals deeper structure
5. **Test-driven debugging** helps catch off-by-one and wraparound bugs

## Related Patterns

- Clock arithmetic (12-hour, 24-hour)
- Circular buffers
- Hash table probing
- Rotation ciphers (Caesar, ROT13)

## Files Modified

- `Sources/Day01.swift` - Main solution
- `Sources/Day01+Input.swift` - Input data
- `Tests/Day01Tests.swift` - Test cases
