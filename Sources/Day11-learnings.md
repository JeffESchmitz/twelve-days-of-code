# Day 11: Reactor - Learnings

## The Challenge

Count paths through a directed graph representing a nuclear reactor's signal flow.

- **Part 1**: Count all paths from "you" to "out"
- **Part 2**: Count paths from "svr" to "out" that visit BOTH "dac" AND "fft" (in any order)

## Key Insights

### 1. Graph Terminology & Representation

**Adjacency List**: The natural representation for this problem
```swift
// String-based (readable but slow)
[String: [String]]  // device -> [outputs]

// Integer-indexed (fast lookups)
[[Int]]  // nodeIndex -> [neighborIndices]
```

**Why Integer Indices are 5x Faster**:
- Array indexing: O(1) with no hashing
- No string comparison/hashing overhead
- Contiguous memory = cache-friendly

### 2. The Path Explosion Problem

**Initial Naive Approach** (Part 2):
```swift
// Enumerate ALL paths, check if each visits dac AND fft
func countPaths(visited: Set<String>) -> Int {
    // EXPONENTIAL - billions of paths!
}
```

**Why It Failed**: In a dense DAG with 585 nodes, path count grows exponentially. Even with cycle detection, enumerating paths takes forever.

**The Insight**: The puzzle states "data can't flow backwards" - it's a **DAG** (Directed Acyclic Graph). This enables:
1. No cycle detection needed (no cycles exist!)
2. Memoization works perfectly
3. Path COUNTING instead of path ENUMERATION

### 3. Dynamic Programming Decomposition

**The Key Formula for Part 2**:
```
Paths visiting both dac and fft =
  (svr→dac × dac→fft × fft→out)   // dac before fft
+ (svr→fft × fft→dac × dac→out)   // fft before dac
```

**Why Multiplication Works**:
- Each segment is independent
- If there are 10 ways to get A→B and 5 ways to get B→C
- There are 10 × 5 = 50 ways to get A→B→C

This turns path ENUMERATION into path COUNTING - from O(2^n) to O(n).

### 4. Memoized DFS for DAGs

```swift
private func countPaths(from start: Int, to end: Int) -> Int {
    var memo = [Int](repeating: -1, count: adjacency.count)

    func dfs(_ node: Int) -> Int {
        if node == end { return 1 }
        if memo[node] >= 0 { return memo[node] }  // Cached!

        let count = adjacency[node].reduce(0) { $0 + dfs($1) }
        memo[node] = count
        return count
    }

    return dfs(start)
}
```

**Why -1 for Unvisited**: 0 is a valid path count (dead end), so use -1 to indicate "not computed yet".

### 5. Higher-Order Functions vs Imperative

We tested both approaches:

**Imperative**:
```swift
var count = 0
for neighbor in adjacency[node] {
    count += dfs(neighbor)
}
```

**Functional**:
```swift
let count = adjacency[node].reduce(0) { $0 + dfs($1) }
```

**Result**: Equal performance! Swift optimizes both equally well. Choose for readability.

### 6. Swift Algorithms: adjacentPairs()

For Part 2's waypoint iteration:

**Before** (manual tuples):
```swift
let segments = [(svrIdx, dacIdx), (dacIdx, fftIdx), (fftIdx, outIdx)]
segments.map { countPaths(from: $0.0, to: $0.1) }.reduce(1, *)
```

**After** (with swift-algorithms):
```swift
[svrIdx, dacIdx, fftIdx, outIdx].adjacentPairs()
    .map { countPaths(from: $0, to: $1) }
    .reduce(1, *)
```

More readable - just list waypoints in order!

## Performance Journey

| Version | Part 1 | Part 2 | Total |
|---------|--------|--------|-------|
| Original (string dict) | ~0.04ms | ~0.5ms | ~0.5ms |
| Integer arrays | ~0.01ms | ~0.1ms | ~0.1ms |
| + Higher-order functions | ~0.006ms | ~0.08ms | ~0.085ms |

**5x speedup** from integer indexing alone!

## Algorithm Pattern Recognition

| Problem Description | Algorithm |
|---------------------|-----------|
| "Count all paths" | DFS with memoization |
| "No cycles" / "can't go backwards" | DAG - use DP |
| "Visit both X and Y" | Decompose into segments, multiply |
| "Shortest path" | BFS (not needed here) |

## Swift Techniques Used

1. **compactMap** for parsing with optional filtering
2. **flatMap** to collect all nodes from parsed edges
3. **reduce(into:)** for building adjacency list
4. **Dictionary(uniqueKeysWithValues:)** for index mapping
5. **adjacentPairs()** from swift-algorithms for clean iteration

## What We Added to the Project

- **swift-algorithms** as direct dependency
- Pattern: Integer-indexed graphs for performance
- Pattern: DAG path counting via decomposition

## The Socratic Method Journey

Started with questions:
1. "What is a graph?" → Nodes and edges
2. "What makes paths different?" → Different sequence of nodes
3. "How do we count without enumerating?" → Memoization + multiplication

This led to understanding WHY the algorithm works, not just WHAT to implement.

## Answers

- **Part 1**: 764
- **Part 2**: 462,444,153,119,850

---

*Key takeaway: When counting paths in a DAG, COUNT don't ENUMERATE. Use memoization and decompose into independent segments.*
