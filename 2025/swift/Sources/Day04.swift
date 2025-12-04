//
// Twelve Days of Code 2025 Day 4
//
// https://adventofcode.com/2025/day/4
//


import AoCTools

final class Day04: AdventOfCodeDay, @unchecked Sendable {
    let title = "Printing Department"
    let grid: Grid<Character>

    init(input: String) {
        // Parse input into Grid<Character>
        self.grid = Grid.parse(input.split(separator: "\n").map(String.init))
    }

    // MARK: - Higher-Order Function Approach

    /// Count neighbors matching a predicate
    private func neighborCount(of point: Point, matching predicate: (Point) -> Bool) -> Int {
        point.neighbors(adjacency: .all).count(where: predicate)
    }

    /// Check if a point is accessible (< 4 neighbors matching predicate)
    private func isAccessible(_ point: Point, in rolls: Set<Point>) -> Bool {
        neighborCount(of: point) { rolls.contains($0) } < 4
    }

    func part1() async -> Int {
        // Filter all rolls to only accessible ones, count the result
        grid.points
            .filter { $0.value == "@" }
            .map(\.key)
            .filter { point in
                neighborCount(of: point) { grid.points[$0] == "@" } < 4
            }
            .count
    }

    func part2() async -> Int {
        let initialRolls = Set(grid.points.filter { $0.value == "@" }.keys)

        // Use sequence to generate removal rounds until no accessible rolls remain
        return sequence(state: initialRolls) { [self] remainingRolls in
            let accessible = remainingRolls.filter { self.isAccessible($0, in: remainingRolls) }
            guard !accessible.isEmpty else { return nil }

            remainingRolls.subtract(accessible)
            return accessible.count
        }
        .reduce(0, +)  // Sum all removal counts
    }
}
