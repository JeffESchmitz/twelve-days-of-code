# Day 7: Laboratories - Learnings

## Problem Summary

A tachyon beam enters a manifold at position `S` and travels downward. When it hits a splitter (`^`), the beam stops and two new beams emerge (left and right). Beams exit when they leave the grid edges.

- **Part 1:** Count how many times beams are split
- **Part 2:** Count how many distinct timelines exist (quantum interpretation - each path is unique)

## Key Insight: The Data Structure Makes the Difference

The critical difference between Part 1 and Part 2 comes down to **one data structure choice**:

| Part | Data Structure | Behavior | What We Count |
|------|---------------|----------|---------------|
| Part 1 | `Set<Int>` | Beams in same column **merge** | Total splits |
| Part 2 | `[Int: Int]` | Timelines in same column **stay separate** | Total timelines |

### Why This Matters

**Part 1 - Beams Merge:**
```
Column 7 has a beam + Column 7 gets another beam = Column 7 has 1 beam
Set automatically deduplicates!
```

**Part 2 - Timelines Don't Merge:**
```
Column 7 has 1 timeline + Column 7 gets 1 timeline = Column 7 has 2 timelines
Dictionary tracks the COUNT at each column
```

## Algorithm Pattern: Row-by-Row Simulation

Both parts use the same simulation pattern:

```
1. Start with initial state at S's column
2. For each row (going downward):
   - For each active position:
     - If splitter (^): split left/right
     - Else: continue downward
   - Remove positions that went off edges
3. Return final count
```

## Code Walkthrough

### Part 1: Counting Splits

```swift
func part1() async -> Int {
    var activeBeams: Set<Int> = [startColumn]  // Set = beams merge
    var splitCount = 0

    for row in 1..<lines.count {
        let line = lines[row]
        var newBeams: Set<Int> = []

        for col in activeBeams {
            let char = line[charIndex]

            if char == "^" {
                splitCount += 1           // Count the split
                newBeams.insert(col - 1)  // Left beam
                newBeams.insert(col + 1)  // Right beam
            } else {
                newBeams.insert(col)      // Continue down
            }
        }

        activeBeams = newBeams.filter { $0 >= 0 && $0 < width }
    }

    return splitCount
}
```

### Part 2: Counting Timelines

```swift
func part2() async -> Int {
    var timelines: [Int: Int] = [startColumn: 1]  // Dictionary = timelines stay separate

    for row in 1..<lines.count {
        let line = lines[row]
        var newTimelines: [Int: Int] = [:]

        for (col, count) in timelines {
            let char = line[charIndex]

            if char == "^" {
                // Each timeline splits into 2 - ADD counts, don't replace
                newTimelines[col - 1, default: 0] += count
                newTimelines[col + 1, default: 0] += count
            } else {
                newTimelines[col, default: 0] += count
            }
        }

        timelines = newTimelines.filter { $0.key >= 0 && $0.key < width }
    }

    return timelines.values.reduce(0, +)  // Sum all timeline counts
}
```

## Pattern Recognition

### "Merge vs. Don't Merge" Pattern

This is a common pattern in AoC problems:

| Scenario | Use | Example |
|----------|-----|---------|
| "How many unique X?" | `Set` | Unique positions visited |
| "How many total X?" | `Dictionary` with counts | Total paths, timelines |
| "Does X exist?" | `Set.contains()` | Is position blocked? |
| "How many X at each Y?" | `Dictionary` | Count per category |

### Simulation Pattern

Row-by-row / step-by-step simulation:
1. Initialize state
2. Loop through time/space
3. Apply rules to transform state
4. Collect results

## Swift Techniques Used

### Dictionary Default Values
```swift
// Instead of:
if newTimelines[col] == nil {
    newTimelines[col] = 0
}
newTimelines[col]! += count

// Use:
newTimelines[col, default: 0] += count
```

### String Character Access
```swift
let charIndex = line.index(line.startIndex, offsetBy: col)
let char = line[charIndex]
```

### Finding Character Position
```swift
if let colIndex = line.firstIndex(of: "S") {
    foundColumn = line.distance(from: line.startIndex, to: colIndex)
}
```

## Performance

Both parts run in ~2ms:
- Part 1: 1.6ms
- Part 2: 2.1ms

The dictionary approach scales well because we're tracking counts, not individual timelines. If we tracked each timeline separately, Part 2 would explode to ~49 trillion items!

## Answers

- **Part 1:** 1626 splits
- **Part 2:** 48,989,920,237,096 timelines

## Key Takeaways

1. **Data structure choice determines behavior** - Set vs Dictionary completely changes the semantics
2. **Read Part 2 carefully** - The "quantum" twist meant paths don't merge
3. **Track counts, not individuals** - When numbers get huge, aggregate!
4. **Same algorithm, different accounting** - Both parts use identical simulation logic
5. **Verify with multiple languages** - Python confirmation caught potential bugs early
