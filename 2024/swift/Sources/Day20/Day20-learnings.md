# Day 20: Race Condition - Implementation & Learnings

## Problem Summary

Day 20 presents a pathfinding problem with a "cheat" mechanic:
- **Part 1**: Count cheats (max 2-step wall bypass) saving ≥100 picoseconds
- **Part 2**: Count cheats (max 20-step wall bypass) saving ≥100 picoseconds

Both parts use the same algorithm with different `maxCheatDistance` parameter.

**Solutions**:
- Part 1: **1323** cheats
- Part 2: **983,905** cheats

---

## The 8-Step Problem Breakdown

### 1. GOAL
Count how many distinct cheats save at least 100 picoseconds.

A "cheat" is defined by:
- Start position (on track)
- End position (on track)
- Cheat duration: Manhattan distance between them (1 to max)

### 2. WORLD
2D grid maze with:
- Walls: `#` (block normal movement)
- Track: `.` (normal pathable space)
- Start: `S` (counts as track)
- End: `E` (counts as track)
- **Single valid path** from S to E (critical!)

### 3. CONSTRAINTS
- Normal movement: 4 cardinal directions, 1 step = 1 picosecond
- Cheating: Can pass through walls for up to 20 picoseconds total
- Must start on track, must end on track
- Exactly one cheat per race

### 4. INPUT FORMAT
Grid of characters, multiple lines, rectangular.

### 5. EXAMPLE TRACE
15×15 grid, baseline path = 84 picoseconds.
- Example cheats save: 2, 4, 6, 8, 10, 12, 20, 36, 38, 40, 64 picoseconds
- Total: 44 unique cheats in example (none save ≥100ps)

### 6. ALGORITHM
**BFS Pathfinding + Manhattan Distance Enumeration**

1. **BFS** from start to end → get distance for every reachable position
2. **Path reconstruction** (optional, for clarity)
3. **For each path position P**:
   - Check all neighbors within Manhattan distance ≤ maxCheatDistance
   - Filter: must be on track (valid end position)
   - Filter: must be forward progress (cheatEndDistance > currentDistance)
   - Calculate: `timeSaved = (cheatEndDistance - currentDistance) - manhattanDistance(P, neighbor)`
   - Count if `timeSaved ≥ 100`

### 7. EDGE CASES
- Cheats ending in walls: filtered (no entry in distances map)
- Backward cheats: filtered (cheatEndDistance must be > currentDistance)
- Different paths, same start/end: naturally counted once (uniqueness by position pair)
- Grid boundaries: naturally handled (out-of-bounds positions not in distances)

### 8. DATA STRUCTURES
- `Deque<Point>`: BFS queue (O(1) popFirst, append)
- `Set<Point>`: Visited tracking (O(1) contains, insert)
- `[Point: Int]`: Distance mapping (O(1) lookup)
- `[Point]`: Path (optional, for understanding)

---

## Implementation Details

### Data Structure Setup

```swift
final class Day20: AdventOfCodeDay {
    let title: String
    let lines: [String]
    let gridPoints: [Point: Character]  // Sendable-safe: not storing Grid
    let start: Point
    let end: Point

    init(input: String) {
        title = "Day 20: Race Condition"
        lines = input.lines
        let grid = Grid<Character>.parse(lines)
        gridPoints = grid.points

        start = gridPoints.first { $0.value == "S" }!.key
        end = gridPoints.first { $0.value == "E" }!.key
    }
}
```

**Key design**: Don't store `Grid<Character>` directly (not Sendable for async functions). Instead, extract `gridPoints` dictionary - this is both lightweight and Sendable.

### BFS with Path Reconstruction

```swift
private func bfsWithPath() -> (distances: [Point: Int], path: [Point])? {
    var queue = Deque<Point>()
    var visited = Set<Point>()
    var distances = [Point: Int]()
    var parent = [Point: Point]()

    queue.append(start)
    visited.insert(start)
    distances[start] = 0

    while let current = queue.popFirst() {
        if current == end { break }

        let currentDistance = distances[current]!

        for neighbor in current.neighbors(adjacency: .cardinal) {
            guard !visited.contains(neighbor) else { continue }
            guard let cell = gridPoints[neighbor], cell != "#" else { continue }

            visited.insert(neighbor)
            distances[neighbor] = currentDistance + 1
            parent[neighbor] = current
            queue.append(neighbor)
        }
    }

    guard distances[end] != nil else { return nil }

    // Reconstruct path
    var path = [Point]()
    var current = end
    while current != start {
        path.append(current)
        guard let prev = parent[current] else { break }
        current = prev
    }
    path.append(start)
    path.reverse()

    return (distances, path)
}
```

**Why reconstruct path?**: Cleaner iteration with ordered positions. Alternative: iterate through distances.keys (unordered but works too).

### Cheat Enumeration

```swift
private func findCheatsWithThreshold(maxCheatDistance: Int, threshold: Int) -> Int {
    guard let result = bfsWithPath() else { return 0 }

    let distances = result.distances
    let path = result.path
    var validCheatCount = 0

    for position in path {
        let currentDistance = distances[position]!

        for dx in -maxCheatDistance...maxCheatDistance {
            for dy in -maxCheatDistance...maxCheatDistance {
                let manhattanDist = abs(dx) + abs(dy)

                guard manhattanDist > 0 && manhattanDist <= maxCheatDistance else { continue }

                let cheatEnd = Point(position.x + dx, position.y + dy)
                guard let cheatEndDistance = distances[cheatEnd] else { continue }
                guard cheatEndDistance > currentDistance else { continue }

                let normalPathLength = cheatEndDistance - currentDistance
                let timeSaved = normalPathLength - manhattanDist

                if timeSaved >= threshold {
                    validCheatCount += 1
                }
            }
        }
    }

    return validCheatCount
}
```

**Key filters**:
1. `manhattanDist > 0`: Skip same position
2. `manhattanDist <= maxCheatDistance`: Respect cheat limit
3. `distances[cheatEnd]` exists: Must be on track
4. `cheatEndDistance > currentDistance`: Forward progress only
5. `timeSaved >= threshold`: Meet savings requirement

### Part 1 vs Part 2

```swift
func part1() async -> Int {
    findCheatsWithThreshold(maxCheatDistance: 2, threshold: 100)
}

func part2() async -> Int {
    findCheatsWithThreshold(maxCheatDistance: 20, threshold: 100)
}
```

**Elegant reuse**: Same algorithm, just different parameter!

---

## Complexity Analysis

### Time Complexity

**BFS Phase**: O(W × H)
- Visit each cell at most once
- Deque operations are O(1)

**Cheat Enumeration Phase**: O(P × C²) where:
- P = path length (typically ~10,000)
- C = maxCheatDistance (2 or 20)
- Checking all (dx, dy) pairs in [-C, C] range = (2C+1)² ≈ 4C²
- Part 1: 2 × 4 = 8 neighbors per position
- Part 2: 20 × 20 = 400 neighbors per position

**Total**:
- Part 1: O(W×H) + O(P × 8) ≈ O(W×H)
- Part 2: O(W×H) + O(P × 400) ≈ O(P × 400)

### Space Complexity

- Distances map: O(P)
- Path array: O(P)
- BFS queue: O(P) worst case
- Visited set: O(P)
- **Total**: O(P)

### Performance (Measured)

| Part | maxCheatDistance | Time |
|------|------------------|------|
| Part 1 | 2 | 33ms |
| Part 2 | 20 | 964ms |

Part 2 is ~30x slower because:
- 400 neighbors per position (vs 8 for Part 1)
- Same path length (~9,000+ positions)
- Still well under 1 second

---

## Key Insights & Patterns

### 1. Single Path Property is Golden

The puzzle explicitly states: "there is only a single path from the start to the end"

**Why this matters**:
- ✅ Every track position has exactly one distance from start
- ✅ BFS finds this unique path in one pass
- ✅ No need for complex pathfinding (A*, Dijkstra's)
- ✅ Pre-computed distances enable O(1) cheat evaluation

**Without single path**: Would need to find "best" path among many - much harder!

### 2. Manhattan Distance is Perfect for Grid Movement

```
Distance from (x1,y1) to (x2,y2) = |x1-x2| + |y1-y2|
```

This is exactly the Manhattan/taxicab distance:
- Represents orthogonal movement only (can't move diagonally)
- Cheat "cost" = Manhattan distance to endpoint
- Time saved = (normal path length) - (cheat distance)

### 3. Enumeration Over Optimization

Instead of searching for optimal cheats:
- Just enumerate ALL possible cheats within distance limit
- Filter by savings threshold
- Count survivors

Works because:
- Cheat distance is bounded (max 20)
- Search space is manageable (~400 neighbors)
- Threshold naturally filters down to answer

### 4. Parametric Algorithm Design

```swift
findCheatsWithThreshold(maxCheatDistance: Int, threshold: Int) -> Int
```

Makes algorithm flexible:
- Part 1: maxCheatDistance=2, threshold=100
- Part 2: maxCheatDistance=20, threshold=100
- Could test with different thresholds: 50, 60, 70...

**Lesson**: Design functions with parameters rather than hard-coding values!

### 5. Forward Progress Filter

```swift
guard cheatEndDistance > currentDistance else { continue }
```

This single line prevents double-counting:
- From position A, we only consider positions B where B is "ahead" on path
- This naturally avoids counting the same (start, end) pair twice
- Also makes logical sense: cheating backward doesn't save time

---

## Testing Strategy

### Example Input
15×15 grid, baseline path = 84 picoseconds, no cheats save ≥100ps

```swift
let testInput = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"""
```

### Test Cases

1. **Example Part 1**: Input testInput, expect 0 cheats (none save ≥100ps)
2. **Solution Part 1**: Input real input, expect 1323 cheats
3. **Example Part 2**: Input testInput, expect 0 cheats
4. **Solution Part 2**: Input real input, expect 983905 cheats

### All Tests Passing ✅

```
✔ Test "Day 20 Part 1" passed
✔ Test "Day 20 Part 1 Solution" passed (1323)
✔ Test "Day 20 Part 2" passed
✔ Test "Day 20 Part 2 Solution" passed (983905)
```

---

## Pattern Recognition for Future Problems

### Similar Problem Patterns

**Grid + Single Path → BFS Distance Mapping**
- Day 20 (this problem)
- Any maze where you need distances to all positions
- Optimal waypoint selection

**Threshold Filtering with Enumeration**
- Day 20 Part 1 and Part 2
- "Count items meeting criteria" → enumerate all, filter
- When brute force is feasible due to bounded search space

**Parametric Algorithm Testing**
- Design with parameters, test multiple values
- Day 20 generalizes to any maxCheatDistance
- Easier debugging and validation

**Manhattan Distance in Grid Problems**
- Day 20 (cheat distance)
- Day 8 (antenna patterns)
- Day 11+ (possibly)
- Whenever you have grid movement costs

### Algorithm Template

```
Problem: Count modifications that meet criteria
1. Map baseline: BFS to get distances/metrics
2. Enumerate modifications: Loop through candidates
3. Evaluate benefit: Calculate impact (time saved, etc)
4. Filter by threshold: Only count valuable modifications
5. Return count
```

---

## Code Organization

```
Sources/Day20/
├── Day20.swift           # Main solution
├── Day20+Input.swift     # Puzzle input
└── Day20-learnings.md    # This file

Tests/
└── Day20Tests.swift      # 4 test cases
```

### Key Files

**Day20.swift** (132 lines):
- Class initialization with grid parsing
- `bfsWithPath()` - BFS + path reconstruction
- `findCheatsWithThreshold()` - Main algorithm
- `part1()` / `part2()` - Entry points

**Day20Tests.swift**:
- Example input test
- Real input test
- Both parts tested

---

## Learnings for 2025

### What Worked Well
1. **BFS with Deque** - Fast, clean, appropriate for unweighted shortest paths
2. **Parametric design** - Same algorithm for Part 1 and 2
3. **Manhattan distance enumeration** - Brute force with bounded search space
4. **Forward progress filtering** - Natural deduplication

### What to Remember
1. Look for "single path" clues - they simplify the problem dramatically
2. Pre-compute distances when possible - enables O(1) lookups
3. Enumerate when search space is bounded - simpler than optimization
4. Filter at the source - cheaper than counting then subtracting

### Transfer This Knowledge To
- Other grid pathfinding problems (especially with single paths)
- Any problem involving distances to all points
- Threshold-based filtering with enumerable candidates
- Parametric solution design (reuse code with different params)

---

## Final Statistics

| Metric | Part 1 | Part 2 |
|--------|--------|--------|
| maxCheatDistance | 2 | 20 |
| Answer | 1323 | 983,905 |
| Time | 33ms | 964ms |
| All Tests | ✅ | ✅ |

**Total for Day 20**: ~1000ms, both parts solved ⭐⭐

---

*Day 20 complete! The elegant single-path property and parametric algorithm design make this a beautiful problem.*
