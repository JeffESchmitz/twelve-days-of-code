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

    func part1() async -> Int {
        var accessibleCount = 0

        // For each position in the grid
        for (point, character) in grid.points {
            // Skip if not a paper roll
            guard character == "@" else { continue }

            // Get all 8 neighbors
            let neighborPoints = point.neighbors(adjacency: .all)

            // Count neighbors that are also paper rolls
            let neighborRollCount = neighborPoints.count { neighborPoint in
                grid.points[neighborPoint] == "@"
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
        var remainingRolls = Set(grid.points.filter { $0.value == "@" }.keys)
        var totalRemoved = 0

        while true {
            // Find all accessible rolls in current state
            let accessible = remainingRolls.filter { point in
                let neighborPoints = point.neighbors(adjacency: .all)
                let neighborRollCount = neighborPoints.count { neighborPoint in
                    remainingRolls.contains(neighborPoint)
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
