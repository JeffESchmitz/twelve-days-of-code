//
// Advent of Code 2024 Day 20
//
// https://adventofcode.com/2024/day/20
//

import AoCTools
import Collections

final class Day20: AdventOfCodeDay {
    let title: String
    let lines: [String]
    let gridPoints: [Point: Character]
    let start: Point
    let end: Point

    init(input: String) {
        title = "Day 20: Race Condition"
        lines = input.lines
        let grid = Grid<Character>.parse(lines)
        gridPoints = grid.points

        // Find start and end positions
        start = gridPoints.first { $0.value == "S" }!.key
        end = gridPoints.first { $0.value == "E" }!.key
    }

    func part1() async -> Int {
        findCheatsWithThreshold(maxCheatDistance: 2, threshold: 100)
    }

    func part2() async -> Int {
        findCheatsWithThreshold(maxCheatDistance: 20, threshold: 100)
    }

    // MARK: - BFS and Path Finding

    private func bfsWithPath() -> (distances: [Point: Int], path: [Point])? {
        var queue = Deque<Point>()
        var visited = Set<Point>()
        var distances = [Point: Int]()
        var parent = [Point: Point]()

        // Setup starting point
        queue.append(start)
        visited.insert(start)
        distances[start] = 0

        // BFS main loop
        while let current = queue.popFirst() {
            // Early exit if we reached the end
            if current == end {
                break
            }

            let currentDistance = distances[current]!

            // Explore all 4 orthogonal neighbors
            for neighbor in current.neighbors(adjacency: .cardinal) {
                // Skip if already visited
                guard !visited.contains(neighbor) else { continue }

                // Skip walls
                guard let cell = gridPoints[neighbor], cell != "#" else { continue }

                // Mark as visited and record distance
                visited.insert(neighbor)
                distances[neighbor] = currentDistance + 1
                parent[neighbor] = current
                queue.append(neighbor)
            }
        }

        // Reconstruct path from start to end
        guard distances[end] != nil else { return nil }

        var path = [Point]()
        var current = end

        while current != start {
            path.append(current)
            guard let prev = parent[current] else { break }
            current = prev
        }
        path.append(start)
        path.reverse()  // Now path goes from start to end

        return (distances, path)
    }

    // MARK: - Cheat Finding

    private func findCheatsWithThreshold(maxCheatDistance: Int, threshold: Int) -> Int {
        guard let result = bfsWithPath() else { return 0 }

        let distances = result.distances
        let path = result.path

        var validCheatCount = 0

        // For each position on the path
        for position in path {
            let currentDistance = distances[position]!

            // Check all positions within Manhattan distance <= maxCheatDistance
            for dx in -maxCheatDistance...maxCheatDistance {
                for dy in -maxCheatDistance...maxCheatDistance {
                    let manhattanDist = abs(dx) + abs(dy)

                    // Skip if outside cheat range or same position
                    guard manhattanDist > 0 && manhattanDist <= maxCheatDistance else { continue }

                    let cheatEnd = Point(position.x + dx, position.y + dy)

                    // Check if cheat end is on the path and has a distance recorded
                    guard let cheatEndDistance = distances[cheatEnd] else { continue }

                    // Only consider forward cheats (going ahead on the path)
                    guard cheatEndDistance > currentDistance else { continue }

                    // Calculate time saved
                    let normalPathLength = cheatEndDistance - currentDistance
                    let timeSaved = normalPathLength - manhattanDist

                    // Count if saves enough time
                    if timeSaved >= threshold {
                        validCheatCount += 1
                    }
                }
            }
        }

        return validCheatCount
    }
}
