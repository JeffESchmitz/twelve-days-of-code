# Day 8: Playground - Learnings

## Problem Summary

Junction boxes are suspended in 3D space. Connect them with strings of lights by finding the closest pairs. When two boxes connect, they form a circuit. Boxes already in the same circuit don't need a new connection.

- **Part 1:** Process 1000 closest pairs, multiply sizes of 3 largest circuits
- **Part 2:** Keep connecting until all boxes form ONE circuit, return X₁ × X₂ of final pair

## Key Insight: Union-Find Data Structure

This is a classic **Union-Find** (Disjoint Set Union) problem - a fundamental CS data structure for tracking connected components.

### What Union-Find Does

Two operations, both nearly O(1):
- **find(x):** Which group/circuit is element x in?
- **union(x, y):** Merge the groups containing x and y

### The "Parent Pointer" Trick

Each element points to a "parent". Follow parents until you find the root (self-parent).

```
Initial: Everyone is their own parent
[A→A] [B→B] [C→C] [D→D]

After union(A, B): B points to A
[A→A, B→A] [C→C] [D→D]

After union(C, D): D points to C
[A→A, B→A] [C→C, D→C]

After union(B, C): C's root points to A's root
[A→A, B→A, C→A, D→C]

find(D): D→C→A (root is A)
```

### Why Class, Not Struct?

```swift
class UnionFind {
    private var parent: [Int]
    private var size: [Int]
    ...
}
```

**The key issue:** `find()` does **path compression** - it mutates `parent` even during a "read" operation:

```swift
func find(_ element: Int) -> Int {
    if parent[element] != element {
        parent[element] = find(parent[element])  // ← MUTATION!
    }
    return parent[element]
}
```

This is **shared mutable state** - the classic use case for reference types (class).

## Algorithm: Partial Kruskal's MST

This problem uses a modified version of **Kruskal's Algorithm** for Minimum Spanning Trees:

1. **Calculate all pairwise distances** between junction boxes
2. **Sort pairs by distance** (shortest first)
3. **Process pairs in order:**
   - If boxes are in different circuits → merge them (union)
   - If already in same circuit → skip
4. **Stop condition:**
   - Part 1: After processing 1000 pairs
   - Part 2: When only 1 circuit remains

### Why Squared Distance?

```swift
func euclideanDistanceSquared(to other: Point3) -> Int {
    let deltaX = x - other.x
    let deltaY = y - other.y
    let deltaZ = z - other.z
    return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
}
```

- **Avoids sqrt():** Keeps everything as `Int`, no floating point
- **Same sort order:** If √a < √b, then a < b
- **Faster:** Integer math vs floating point

## Code Walkthrough

### Data Structure: JunctionPair

```swift
struct JunctionPair: Comparable {
    let distance: Int
    let firstIndex: Int
    let secondIndex: Int

    static func < (lhs: JunctionPair, rhs: JunctionPair) -> Bool {
        lhs.distance < rhs.distance
    }
}
```

Making it `Comparable` means we can just call `pairs.sort()`.

### Part 1: Process 1000 Pairs

```swift
func part1() async -> Int {
    let boxCount = junctionBoxes.count

    // Generate all pairs with distances
    var pairs: [JunctionPair] = []
    for firstIdx in 0..<boxCount {
        for secondIdx in (firstIdx + 1)..<boxCount {
            let dist = junctionBoxes[firstIdx].euclideanDistanceSquared(to: junctionBoxes[secondIdx])
            pairs.append(JunctionPair(distance: dist, firstIndex: firstIdx, secondIndex: secondIdx))
        }
    }

    // Sort by distance
    pairs.sort()

    // Process 1000 shortest pairs
    let unionFind = UnionFind(boxCount)
    for pairIndex in 0..<min(1000, pairs.count) {
        let pair = pairs[pairIndex]
        _ = unionFind.union(pair.firstIndex, pair.secondIndex)
    }

    // Multiply top 3 circuit sizes
    let sizes = unionFind.circuitSizes()
    return sizes.prefix(3).reduce(1, *)
}
```

### Part 2: Connect All Boxes

```swift
func part2() async -> Int {
    // ... same setup ...

    var circuitsRemaining = boxCount
    var lastMergedPair: JunctionPair?

    for pair in pairs {
        if unionFind.union(pair.firstIndex, pair.secondIndex) {
            lastMergedPair = pair
            circuitsRemaining -= 1

            if circuitsRemaining == 1 { break }
        }
    }

    guard let finalPair = lastMergedPair else { return 0 }
    return junctionBoxes[finalPair.firstIndex].x * junctionBoxes[finalPair.secondIndex].x
}
```

**Key insight:** To merge N boxes into 1 circuit requires exactly **N-1 successful unions**.

## Union-Find Optimizations

### 1. Path Compression

During `find()`, make every node point directly to root:

```swift
func find(_ element: Int) -> Int {
    if parent[element] != element {
        parent[element] = find(parent[element])  // Point to root
    }
    return parent[element]
}
```

**Before find(D):** D→C→B→A
**After find(D):** D→A, C→A, B→A (flattened!)

### 2. Union by Size

Attach smaller tree to larger tree:

```swift
func union(_ first: Int, _ second: Int) -> Bool {
    var rootFirst = find(first)
    var rootSecond = find(second)

    if rootFirst == rootSecond { return false }

    // Attach smaller to larger
    if size[rootFirst] < size[rootSecond] {
        swap(&rootFirst, &rootSecond)
    }

    parent[rootSecond] = rootFirst
    size[rootFirst] += size[rootSecond]
    return true
}
```

**Combined complexity:** Nearly O(α(n)) per operation, where α is inverse Ackermann (effectively constant).

## Complexity Analysis

| Operation | Complexity |
|-----------|------------|
| Generate pairs | O(n²) |
| Sort pairs | O(n² log n²) = O(n² log n) |
| Process pairs | O(n² × α(n)) ≈ O(n²) |
| **Total** | **O(n² log n)** |

For 1000 boxes: ~500,000 pairs, very manageable.

## Performance & Optimization

### Initial Debug Build

```
Day 8 'Playground' part 1 took 777ms
Day 8 'Playground' part 2 took 779ms
Total time: 1556ms
```

### Release Build Baseline (Imperative)

```
Day 8 'Playground' part 1 took 40.4ms
Day 8 'Playground' part 2 took 34.4ms
Total time: 74.9ms
```

**20x faster** just by using release mode!

### Optimization Journey

| Version | Part 1 | Part 2 | Total | vs Baseline |
|---------|--------|--------|-------|-------------|
| Baseline (imperative) | 40.4ms | 34.4ms | **74.9ms** | — |
| Higher-order (no precompute) | 37.2ms | 35.3ms | **72.6ms** | 3% faster |
| **Higher-order + precompute** | 0.08ms | 0.08ms | **0.16ms** | **99.8% faster** |

### Key Optimization: Precomputation

The massive win came from **precomputing sorted pairs in `init()`**:

```swift
init(input: String) {
    // Parse boxes...
    self.junctionBoxes = boxes

    // Generate all pairs using flatMap and sort ONCE
    self.sortedPairs = boxes.indices.flatMap { firstIdx in
        ((firstIdx + 1)..<boxes.count).map { secondIdx in
            JunctionPair(
                distance: boxes[firstIdx].euclideanDistanceSquared(to: boxes[secondIdx]),
                firstIndex: firstIdx,
                secondIndex: secondIdx
            )
        }
    }.sorted()
}
```

Both `part1()` and `part2()` now reuse the same sorted pairs - no duplicate work!

### Higher-Order Functions Refactoring

**Before (nested loops):**
```swift
var pairs: [JunctionPair] = []
for firstIdx in 0..<boxCount {
    for secondIdx in (firstIdx + 1)..<boxCount {
        let dist = junctionBoxes[firstIdx].euclideanDistanceSquared(to: junctionBoxes[secondIdx])
        pairs.append(JunctionPair(distance: dist, firstIndex: firstIdx, secondIndex: secondIdx))
    }
}
```

**After (flatMap + map):**
```swift
let pairs = boxes.indices.flatMap { firstIdx in
    ((firstIdx + 1)..<boxes.count).map { secondIdx in
        JunctionPair(
            distance: boxes[firstIdx].euclideanDistanceSquared(to: boxes[secondIdx]),
            firstIndex: firstIdx,
            secondIndex: secondIdx
        )
    }
}
```

**circuitSizes() before:**
```swift
var sizes: [Int] = []
for index in 0..<parent.count where parent[index] == index {
    sizes.append(size[index])
}
return sizes.sorted(by: >)
```

**circuitSizes() after:**
```swift
parent.enumerated()
    .filter { $0.element == $0.offset }  // Root nodes only
    .map { size[$0.offset] }
    .sorted(by: >)
```

### Why Higher-Order + Precompute Wins

1. **Precomputation** - Do expensive work once, reuse everywhere
2. **flatMap + map** - Slightly faster than nested loops (~3%)
3. **Cleaner code** - Fewer lines, more declarative intent
4. **No duplicate work** - Both parts share sorted pairs

## Pattern Recognition

### When to Use Union-Find

- **"Are X and Y connected?"** → Union-Find
- **"Group elements by connectivity"** → Union-Find
- **"Find connected components"** → Union-Find or BFS/DFS
- **"Merge groups incrementally"** → Union-Find

### Related Algorithms

| Problem Type | Algorithm |
|--------------|-----------|
| Minimum Spanning Tree | Kruskal's (Union-Find) or Prim's |
| Shortest Path | BFS, Dijkstra |
| Connected Components | BFS/DFS or Union-Find |
| Cycle Detection | Union-Find or DFS |

## Swift Techniques Used

### Comparable Protocol for Custom Sorting

```swift
struct JunctionPair: Comparable {
    static func < (lhs: JunctionPair, rhs: JunctionPair) -> Bool {
        lhs.distance < rhs.distance
    }
}

pairs.sort()  // Uses our < implementation
```

### Class for Shared Mutable State

Union-Find needs reference semantics because:
- `find()` mutates during "reads" (path compression)
- Single source of truth for circuit membership
- Mutations should be visible everywhere

### Nested Loop Pair Generation

```swift
for firstIdx in 0..<boxCount {
    for secondIdx in (firstIdx + 1)..<boxCount {
        // Only consider i < j to avoid duplicates
    }
}
```

Generates n×(n-1)/2 unique pairs.

## Key Takeaways

1. **Union-Find is a fundamental data structure** - Know it for connectivity problems
2. **Path compression + union by size** - Two optimizations that make it nearly O(1)
3. **Squared distance avoids floating point** - Same sort order, integer math
4. **Class vs Struct: shared mutable state** - Union-Find mutates during "reads"
5. **Comparable protocol simplifies sorting** - Define `<` once, use `sort()` everywhere
6. **Partial Kruskal's** - Process edges in order, stop when condition met

## Answers

- **Part 1:** 54,600 (top 3 circuit sizes: 65 × 30 × 28)
- **Part 2:** 107,256,172 (X coordinates of final pair)
