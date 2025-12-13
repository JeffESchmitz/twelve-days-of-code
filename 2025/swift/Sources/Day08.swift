//
// Twelve Days of Code 2025 Day 8
//
// https://adventofcode.com/2025/day/8
//

import AoCTools

// MARK: - Point3 Extension for Euclidean Distance

extension Point3 {
    /// Squared Euclidean distance to another point.
    /// We use squared distance to avoid floating point sqrt -
    /// sorting by d² gives the same order as sorting by d!
    func euclideanDistanceSquared(to other: Point3) -> Int {
        let deltaX = x - other.x
        let deltaY = y - other.y
        let deltaZ = z - other.z
        return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
    }
}

// MARK: - Union-Find (Disjoint Set Union)
// Tracks which junction boxes are in the same circuit

class UnionFind {
    private var parent: [Int]  // parent[i] = parent of element i
    private var size: [Int]    // size[i] = size of circuit rooted at i

    init(_ count: Int) {
        // Everyone starts as their own parent (own circuit)
        self.parent = Array(0..<count)
        // Every circuit starts with size 1
        self.size = Array(repeating: 1, count: count)
    }

    /// Find the root of element's circuit (with path compression)
    func find(_ element: Int) -> Int {
        if parent[element] != element {
            // Path compression: point directly to root
            parent[element] = find(parent[element])
        }
        return parent[element]
    }

    /// Merge circuits containing first and second elements.
    /// Returns true if they were in different circuits (merge happened).
    func union(_ first: Int, _ second: Int) -> Bool {
        var rootFirst = find(first)
        var rootSecond = find(second)

        // Already in same circuit
        if rootFirst == rootSecond {
            return false
        }

        // Union by size: attach smaller tree to larger tree
        if size[rootFirst] < size[rootSecond] {
            swap(&rootFirst, &rootSecond)
        }

        // Attach rootSecond's tree to rootFirst
        parent[rootSecond] = rootFirst
        size[rootFirst] += size[rootSecond]

        return true
    }

    /// Get sizes of all circuits, sorted descending
    func circuitSizes() -> [Int] {
        var sizes: [Int] = []
        for index in 0..<parent.count where parent[index] == index {
            // This is a root - add its circuit size
            sizes.append(size[index])
        }
        return sizes.sorted(by: >)
    }
}

// MARK: - Junction Box Pair
// Represents a pair of junction boxes with their distance

struct JunctionPair: Comparable {
    let distance: Int
    let firstIndex: Int
    let secondIndex: Int

    static func < (lhs: JunctionPair, rhs: JunctionPair) -> Bool {
        lhs.distance < rhs.distance
    }
}

final class Day08: AdventOfCodeDay {
    let title = "Playground"

    // Parsed junction box positions
    let junctionBoxes: [Point3]

    init(input: String) {
        // Parse each line: "162,817,812" -> Point3(162, 817, 812)
        self.junctionBoxes = input.lines.compactMap { line -> Point3? in
            let nums = line.integers()
            guard nums.count == 3 else { return nil }
            return Point3(nums[0], nums[1], nums[2])
        }
    }

    func part1() async -> Int {
        let boxCount = junctionBoxes.count

        // Step 1: Generate all pairs with their distances
        var pairs: [JunctionPair] = []

        for firstIdx in 0..<boxCount {
            for secondIdx in (firstIdx + 1)..<boxCount {
                let dist = junctionBoxes[firstIdx].euclideanDistanceSquared(to: junctionBoxes[secondIdx])
                pairs.append(JunctionPair(distance: dist, firstIndex: firstIdx, secondIndex: secondIdx))
            }
        }

        // Step 2: Sort pairs by distance (shortest first)
        pairs.sort()

        // Step 3: Process the 1000 shortest pairs using Union-Find
        let unionFind = UnionFind(boxCount)
        let pairsToProcess = 1000

        for pairIndex in 0..<min(pairsToProcess, pairs.count) {
            let pair = pairs[pairIndex]
            // Try to merge - if already same circuit, nothing happens
            _ = unionFind.union(pair.firstIndex, pair.secondIndex)
        }

        // Step 4: Get circuit sizes and multiply top 3
        let sizes = unionFind.circuitSizes()
        let top3 = sizes.prefix(3)

        return top3.reduce(1, *)
    }

    func part2() async -> Int {
        let boxCount = junctionBoxes.count

        // Step 1: Generate all pairs with their distances (same as part1)
        var pairs: [JunctionPair] = []

        for firstIdx in 0..<boxCount {
            for secondIdx in (firstIdx + 1)..<boxCount {
                let dist = junctionBoxes[firstIdx].euclideanDistanceSquared(to: junctionBoxes[secondIdx])
                pairs.append(JunctionPair(distance: dist, firstIndex: firstIdx, secondIndex: secondIdx))
            }
        }

        // Step 2: Sort pairs by distance (shortest first)
        pairs.sort()

        // Step 3: Process pairs until all boxes are in ONE circuit
        let unionFind = UnionFind(boxCount)
        var circuitsRemaining = boxCount  // Start with each box in its own circuit
        var lastMergedPair: JunctionPair?

        for pair in pairs {
            // Try to merge - if successful, we joined two circuits
            if unionFind.union(pair.firstIndex, pair.secondIndex) {
                lastMergedPair = pair
                circuitsRemaining -= 1

                // All boxes in one circuit?
                if circuitsRemaining == 1 {
                    break
                }
            }
        }

        // Step 4: Multiply X coordinates of the last merged pair
        guard let finalPair = lastMergedPair else { return 0 }

        let xFirst = junctionBoxes[finalPair.firstIndex].x
        let xSecond = junctionBoxes[finalPair.secondIndex].x

        return xFirst * xSecond
    }
}
