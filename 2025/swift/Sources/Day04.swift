//
// Twelve Days of Code 2025 Day 4
//
// https://adventofcode.com/2025/day/4
//


import AoCTools

final class Day04: AdventOfCodeDay, @unchecked Sendable {
    let title = "Printing Department"
    let grid: Grid<Character>
    let rollPositions: Set<Point>

    // Optimization 1: Inline neighbor offsets to avoid allocations
    private static let neighborOffsets: [(Int, Int)] = [
        (-1, -1), (-1, 0), (-1, 1),  // NW, N, NE
        (0, -1),           (0, 1),    // W,     E
        (1, -1),  (1, 0),  (1, 1)     // SW, S, SE
    ]

    init(input: String) {
        // Parse input into Grid<Character>
        self.grid = Grid.parse(input.split(separator: "\n").map(String.init))

        // Optimization 2: Pre-compute roll positions once
        self.rollPositions = Set(grid.points.filter { $0.value == "@" }.keys)
    }

    func part1() async -> Int {
        var accessibleCount = 0

        // For each position in the grid
        for (point, character) in grid.points {
            // Skip if not a paper roll
            guard character == "@" else { continue }

            // Count neighbors directly (avoid array allocation)
            var neighborRollCount = 0
            for (dx, dy) in Self.neighborOffsets {
                let neighbor = Point(point.x + dx, point.y + dy)
                if rollPositions.contains(neighbor) {
                    neighborRollCount += 1
                }
            }

            // Check if accessible (fewer than 4 neighbors)
            if neighborRollCount < 4 {
                accessibleCount += 1
            }
        }

        return accessibleCount
    }

    func part2() async -> Int {
        // Part 2: Iterative removal simulation
        var remainingRolls = rollPositions
        var totalRemoved = 0

        while true {
            // Find all accessible rolls in current state
            let accessible = remainingRolls.filter { point in
                var neighborRollCount = 0
                for (dx, dy) in Self.neighborOffsets {
                    let neighbor = Point(point.x + dx, point.y + dy)
                    if remainingRolls.contains(neighbor) {
                        neighborRollCount += 1
                    }
                }
                return neighborRollCount < 4
            }

            // If no rolls are accessible, we're done
            if accessible.isEmpty {
                break
            }

            // Remove all accessible rolls
            for point in accessible {
                remainingRolls.remove(point)
            }

            totalRemoved += accessible.count
        }

        return totalRemoved
    }
}
