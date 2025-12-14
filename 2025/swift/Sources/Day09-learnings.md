# Day 9: Movie Theater - Learnings

## Problem Summary

Find the largest rectangle using red tiles as opposite corners. Red tiles are marked positions on a movie theater floor.

- **Part 1:** Find largest rectangle with any two red tiles as opposite corners
- **Part 2:** Rectangle must only contain red or green tiles (polygon constraint)

## Key Insight: Inclusive Area Calculation

The area formula counts both corner tiles as part of the rectangle:

```
Area = (|x2 - x1| + 1) × (|y2 - y1| + 1)
```

**Example**: Corners at (2,5) and (11,1)
- Width = |11-2| + 1 = 10 tiles
- Height = |5-1| + 1 = 5 tiles
- Area = 10 × 5 = 50

This is different from mathematical rectangle area where `Area = width × height`.

## Part 1: Simple Brute Force

O(n²) - check all pairs of red tiles:

```swift
func part1() async -> Int {
    var maxArea = 0

    for firstIdx in 0..<tiles.count {
        for secondIdx in (firstIdx + 1)..<tiles.count {
            let tile1 = tiles[firstIdx]
            let tile2 = tiles[secondIdx]

            let width = abs(tile2.x - tile1.x) + 1
            let height = abs(tile2.y - tile1.y) + 1
            let area = width * height

            maxArea = max(maxArea, area)
        }
    }

    return maxArea
}
```

## Part 2: Polygon Containment

The red tiles form a polygon when connected in order. Green tiles are:
1. **Edge tiles**: Points between consecutive red tiles
2. **Interior tiles**: Points inside the polygon

A rectangle is valid if it lies entirely within this polygon.

### Building the Polygon

Red tiles are connected in sequence (wrapping around):

```swift
for idx in 0..<tiles.count {
    let current = tiles[idx]
    let next = tiles[(idx + 1) % tiles.count]

    if current.y == next.y {
        // Horizontal edge
        horizontalEdges.append(HorizontalEdge(
            yPos: current.y,
            xMin: min(current.x, next.x),
            xMax: max(current.x, next.x)
        ))
    } else {
        // Vertical edge
        verticalEdges.append(VerticalEdge(
            xPos: current.x,
            yMin: min(current.y, next.y),
            yMax: max(current.y, next.y)
        ))
    }
}
```

### Point-in-Polygon: Ray Casting

The classic algorithm for determining if a point is inside a polygon:

```swift
func isInsidePolygon(_ point: Point) -> Bool {
    var crossings = 0
    for edge in verticalEdges {
        // Cast ray to the right, count crossings
        // Half-open interval handles vertex edge cases
        if edge.xPos > point.x &&
           edge.yMin <= point.y &&
           point.y < edge.yMax {
            crossings += 1
        }
    }
    return crossings % 2 == 1  // Odd = inside
}
```

**How it works:**
1. Cast a ray from the point horizontally to the right
2. Count how many polygon edges the ray crosses
3. Odd crossings = inside, Even crossings = outside

```
       Outside         Inside         Outside
    -------|------------|--------------|-------
         edge1        edge2         edge3
           ↑            ↑             ↑
      1 crossing   2 crossings   3 crossings
         (odd)       (even)        (odd)
```

### Rectangle Validation

A rectangle is valid if:
1. All four corners are inside or on the polygon boundary
2. No polygon edge crosses through the rectangle's interior

```swift
func rectangleIsValid(minX: Int, minY: Int, maxX: Int, maxY: Int) -> Bool {
    // Check all four corners
    guard isValidPoint(Point(minX, minY)),
          isValidPoint(Point(minX, maxY)),
          isValidPoint(Point(maxX, minY)),
          isValidPoint(Point(maxX, maxY)) else {
        return false
    }

    // Check no vertical edge pierces interior
    for edge in verticalEdges
    where minX < edge.xPos && edge.xPos < maxX &&
          edge.yMin < maxY && edge.yMax > minY {
        return false
    }

    // Check no horizontal edge pierces interior
    for edge in horizontalEdges
    where minY < edge.yPos && edge.yPos < maxY &&
          edge.xMin < maxX && edge.xMax > minX {
        return false
    }

    return true
}
```

**Why check edge piercing?**

Consider a U-shaped polygon. Two corners deep inside the U could have all four rectangle corners valid, but the rectangle might extend outside the U:

```
    ┌─────────────┐
    │   ┌─────┐   │
    │   │     │   │
    │   │ BAD │   │  ← Rectangle crosses outside!
    │   └─────┘   │
    │             │
    └─────────────┘
```

The edge-piercing check catches these cases.

## Complexity Analysis

| Part | Time Complexity | Space Complexity |
|------|----------------|------------------|
| Part 1 | O(n²) | O(n) |
| Part 2 | O(n³) | O(n) |

- **Part 1**: Check all n² pairs, O(1) per pair
- **Part 2**: Check all n² pairs, O(n) validation per pair

## Performance

```
Part 1: ~15ms
Part 2: ~8.5 seconds
```

Part 2 is slower due to the O(n) polygon validation for each of the O(n²) pairs.

### Potential Optimizations

1. **Early termination**: Skip pairs where max possible area < current max
2. **Precompute boundary set**: O(1) lookup for boundary points
3. **Spatial indexing**: Segment trees for faster edge intersection queries

For this puzzle size, the brute force is acceptable.

## Swift Techniques Used

### Private Structs for Edge Types

```swift
private struct HorizontalEdge {
    let yPos: Int
    let xMin: Int
    let xMax: Int
}

private struct VerticalEdge {
    let xPos: Int
    let yMin: Int
    let yMax: Int
}
```

Using structs instead of tuples satisfies SwiftLint's `large_tuple` rule.

### Nested Functions for Encapsulation

```swift
func part2() async -> Int {
    // Helper functions defined inside part2
    func isOnBoundary(_ point: Point) -> Bool { ... }
    func isInsidePolygon(_ point: Point) -> Bool { ... }
    func isValidPoint(_ point: Point) -> Bool { ... }
    func rectangleIsValid(...) -> Bool { ... }

    // Main logic uses these helpers
}
```

This keeps helper functions scoped to where they're used.

### Guard with Multiple Conditions

```swift
guard isValidPoint(Point(minX, minY)),
      isValidPoint(Point(minX, maxY)),
      isValidPoint(Point(maxX, minY)),
      isValidPoint(Point(maxX, maxY)) else {
    return false
}
```

Clean way to validate multiple conditions.

### For-Where for Filtering

```swift
for edge in verticalEdges
where minX < edge.xPos && edge.xPos < maxX &&
      edge.yMin < maxY && edge.yMax > minY {
    return false
}
```

More readable than `if` inside the loop.

## Pattern Recognition

### When to Use Ray Casting

- Point-in-polygon queries
- Determining inside vs outside regions
- Works for any simple (non-self-intersecting) polygon

### Axis-Aligned Polygon Simplification

Since all edges are horizontal or vertical:
- Only need to check vertical edges for ray casting
- Simpler intersection math (no slope calculations)
- Natural decomposition into horizontal/vertical edge lists

### The "Two-Pass Validation" Pattern

1. **First pass**: Check if candidate meets basic criteria (corners valid)
2. **Second pass**: Check for disqualifying conditions (edge intersections)

This is more efficient than checking everything at once.

## Key Takeaways

1. **Read the problem carefully** - "inclusive" area counting is different from mathematical area
2. **Ray casting is fundamental** - Know this algorithm for polygon problems
3. **Corners valid ≠ rectangle valid** - Must also check edge intersections
4. **Axis-aligned simplifies everything** - Take advantage of grid-aligned problems
5. **O(n³) can be acceptable** - For reasonable n, brute force often works
6. **Private structs > large tuples** - Cleaner code and satisfies linting

## Related Patterns

| Problem Type | Algorithm |
|--------------|-----------|
| Point in polygon | Ray casting |
| Polygon area | Shoelace formula |
| Convex hull | Graham scan, Andrew's algorithm |
| Rectangle intersection | Separating axis theorem |
| Polygon clipping | Sutherland-Hodgman |

## Answers

- **Part 1:** 4,746,238,001 (largest rectangle with any two red corners)
- **Part 2:** 1,552,139,370 (largest rectangle within polygon constraint)
