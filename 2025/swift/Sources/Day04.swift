//
// Twelve Days of Code 2025 Day 4
//
// https://adventofcode.com/2025/day/4
//
// Functional Programming Approach
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// This implementation prioritizes readability through:
//   • Immutability: No mutable accumulators or state
//   • Composition: Small, reusable functions combined into pipelines
//   • Declarative style: Describes WHAT to compute, not HOW
//   • Higher-order functions: map, filter, reduce, sequence
//
// Performance: ~175ms (same as imperative approach - 4% difference)
// Readability: High - intent clear from function composition
//

import AoCTools

final class Day04: AdventOfCodeDay, @unchecked Sendable {
    let title = "Printing Department"
    let grid: Grid<Character>

    init(input: String) {
        self.grid = Grid.parse(input.split(separator: "\n").map(String.init))
    }

    // MARK: - Reusable Helper Functions

    /// Count neighbors of a point that match a given predicate.
    ///
    /// This abstraction encapsulates the neighbor-checking pattern,
    /// making it reusable across both parts of the solution.
    ///
    /// - Parameters:
    ///   - point: The point whose neighbors to check
    ///   - predicate: Condition that neighbors must satisfy
    /// - Returns: Number of neighbors matching the predicate
    private func neighborCount(of point: Point, matching predicate: (Point) -> Bool) -> Int {
        point.neighbors(adjacency: .all).count(where: predicate)
    }

    /// Determine if a paper roll is accessible (has fewer than 4 neighboring rolls).
    ///
    /// Semantic helper that expresses business logic clearly:
    /// "Is this roll accessible?" rather than "Does it have < 4 neighbors?"
    ///
    /// - Parameters:
    ///   - point: The roll position to check
    ///   - rolls: The current set of remaining rolls
    /// - Returns: True if accessible (< 4 neighbors)
    private func isAccessible(_ point: Point, in rolls: Set<Point>) -> Bool {
        neighborCount(of: point) { rolls.contains($0) } < 4
    }

    /// Part 1: Count initially accessible paper rolls.
    ///
    /// Functional pipeline:
    ///   1. Filter grid to paper rolls (@)
    ///   2. Extract point coordinates
    ///   3. Filter to accessible rolls (< 4 neighbors)
    ///   4. Count the result
    ///
    /// No mutable state - entire computation expressed as data transformation.
    func part1() async -> Int {
        grid.points
            .filter { $0.value == "@" }        // Find all paper rolls
            .map(\.key)                         // Extract positions
            .filter { point in                  // Keep only accessible ones
                neighborCount(of: point) { grid.points[$0] == "@" } < 4
            }
            .count                              // Count the result
    }

    /// Part 2: Simulate iterative removal of accessible rolls.
    ///
    /// Uses `sequence(state:next:)` to generate values lazily:
    ///   • Maintains immutable state transformation (no while loop)
    ///   • Each iteration returns count of removed rolls
    ///   • Returns nil when no accessible rolls remain (terminates sequence)
    ///   • reduce(0, +) sums all removal counts
    ///
    /// This replaces imperative while-loop + accumulator pattern with
    /// functional generator + reducer pattern.
    func part2() async -> Int {
        let initialRolls = Set(grid.points.filter { $0.value == "@" }.keys)

        return sequence(state: initialRolls) { [self] remainingRolls in
            // Find accessible rolls in current state
            let accessible = remainingRolls.filter { self.isAccessible($0, in: remainingRolls) }

            // Terminate if none accessible
            guard !accessible.isEmpty else { return nil }

            // Update state and return count for this round
            remainingRolls.subtract(accessible)
            return accessible.count
        }
        .reduce(0, +)  // Sum all removal counts across all rounds
    }
}
