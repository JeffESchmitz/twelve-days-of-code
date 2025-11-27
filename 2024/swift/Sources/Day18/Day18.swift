//
// Advent of Code 2024 Day 18
//
// https://adventofcode.com/2024/day/18
//

import AoCTools
import Collections

final class Day18: AdventOfCodeDay {
    let title = "RAM Run"
    let coordinates: [Point]

    init(input: String) {
        // Parse coordinates in order from input
        coordinates = input.split(separator: "\n").map { line in
            let parts = line.split(separator: ",")
            let x = Int(String(parts[0]))!
            let y = Int(String(parts[1]))!
            return Point(x, y)
        }
    }

    func part1() async -> Int {
        findShortestPath(gridSize: 70, byteCount: 1024)
    }

    func part2() async -> Int {
        findFirstBlockingByte(gridSize: 70)
    }

    func findFirstBlockingByte(gridSize: Int) -> Int {
        // Binary search for the first byte that blocks the path
        var left = 0
        var right = coordinates.count - 1

        while left < right {
            let mid = (left + right) / 2

            if hasPath(gridSize: gridSize, withByteCount: mid + 1) {
                // Path still exists, blocker is later
                left = mid + 1
            } else {
                // Path is blocked, blocker is at mid or earlier
                right = mid
            }
        }

        // Found the first blocking byte
        let blockingByte = coordinates[left]
        print("First blocking byte: \(blockingByte.x),\(blockingByte.y)")
        return 0
    }

    // MARK: - Private Methods

    private func hasPath(gridSize: Int, withByteCount count: Int) -> Bool {
        findShortestPath(gridSize: gridSize, byteCount: count) >= 0
    }

    func findShortestPath(gridSize: Int, byteCount: Int) -> Int {
        // Create set of corrupted locations from first N bytes
        let corrupted = Set(coordinates.prefix(byteCount))

        let start = Point(0, 0)
        let goal = Point(gridSize, gridSize)

        // BFS to find shortest path
        var queue = Deque<(point: Point, steps: Int)>()
        var visited = Set<Point>()

        queue.append((start, 0))
        visited.insert(start)

        while let (position, steps) = queue.popFirst() {
            // Check if we reached the goal
            if position == goal {
                return steps
            }

            // Explore all 4 neighbors
            for neighbor in position.orthogonalNeighbors() {
                // Check if neighbor is valid
                guard isValid(neighbor, gridSize: gridSize),
                      !corrupted.contains(neighbor),
                      !visited.contains(neighbor)
                else {
                    continue
                }

                queue.append((neighbor, steps + 1))
                visited.insert(neighbor)
            }
        }

        // No path found
        return -1
    }

    private func isValid(_ point: Point, gridSize: Int) -> Bool {
        point.x >= 0 && point.x <= gridSize &&
            point.y >= 0 && point.y <= gridSize
    }
}
