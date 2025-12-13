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
        parent.enumerated()
            .filter { $0.element == $0.offset }  // Root nodes only
            .map { size[$0.offset] }
            .sorted(by: >)
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

    // Pre-computed sorted pairs (shared between part1 and part2)
    private let sortedPairs: [JunctionPair]

    init(input: String) {
        // Parse each line: "162,817,812" -> Point3(162, 817, 812)
        let boxes = input.lines.compactMap { line -> Point3? in
            let nums = line.integers()
            guard nums.count == 3 else { return nil }
            return Point3(nums[0], nums[1], nums[2])
        }
        self.junctionBoxes = boxes

        // Generate all pairs using flatMap (higher-order) and sort once
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

    func part1() async -> Int {
        let unionFind = UnionFind(junctionBoxes.count)

        // Process 1000 shortest pairs
        sortedPairs.prefix(1000).forEach { pair in
            _ = unionFind.union(pair.firstIndex, pair.secondIndex)
        }

        // Multiply top 3 circuit sizes
        return unionFind.circuitSizes().prefix(3).reduce(1, *)
    }

    func part2() async -> Int {
        let unionFind = UnionFind(junctionBoxes.count)
        var circuitsRemaining = junctionBoxes.count
        var lastMergedPair: JunctionPair?

        // union() has side effects, can't use where clause
        // swiftlint:disable for_where
        for pair in sortedPairs {
            if unionFind.union(pair.firstIndex, pair.secondIndex) {
                lastMergedPair = pair
                circuitsRemaining -= 1
                if circuitsRemaining == 1 { break }
            }
        }
        // swiftlint:enable for_where

        guard let finalPair = lastMergedPair else { return 0 }
        return junctionBoxes[finalPair.firstIndex].x * junctionBoxes[finalPair.secondIndex].x
    }
}
