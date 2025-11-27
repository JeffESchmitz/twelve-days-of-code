//
// Advent of Code 2024 Day 10
//
// https://adventofcode.com/2024/day/10
//

import AoCTools
import Algorithms

final class Day10: AdventOfCodeDay {
    let title = "Hoof It"

    let grid: [Point: Int] // Store the parsed grid as a dictionary

    
    init(input: String) {
        self.grid = Dictionary(
            uniqueKeysWithValues: input
                .lines
                .enumerated()
                .flatMap { y, line in
                    line
                        .enumerated()
                        .map { x, char in
                            let point = Point(x, y)
                            let height = Int(String(char)) ?? -1
                            return (point, height)
                        }
                }
        )
    }

    func part1() async -> Int {
        let trailheads = grid.filter { $0.value == 0 }.keys
        return trailheads.reduce(0) { $0 + findReachableNines(from: $1) }
    }

    func part2() async -> Int {
        let trailheads = grid.filter { $0.value == 0 }.keys
        
        // Calculate the sum of all trailhead ratings
        let totalRating = trailheads.reduce(0) { total, trailhead in
            total + bfsPaths(from: trailhead)
        }
        
        return totalRating
    }
}

extension Day10 {
    func findReachableNines(from start: Point) -> Int {
        var visited = Set<Point>()
        var queue = [start]
        var reachableNines = 0

        while !queue.isEmpty {
            let current = queue.removeFirst()

            if visited.contains(current) {
                continue
            }
            visited.insert(current)

            guard let currentHeight = grid[current] else { continue }

            if currentHeight == 9 {
                reachableNines += 1
            }

            for neighbor in current.orthogonalNeighbors() {
                if let neighborHeight = grid[neighbor], neighborHeight == currentHeight + 1 {
                    queue.append(neighbor)
                }
            }
        }

        return reachableNines
    }

    func bfsPaths(from start: Point) -> Int {
        var queue: [(Point, [Point])] = [(start, [start])]
        var visitedPaths = Set<[Point]>()
        var distinctPaths = Set<[Point]>()
        
        while !queue.isEmpty {
            let (current, path) = queue.removeFirst()

            // Check if we've reached a height of 9
            if grid[current] == 9 {
                distinctPaths.insert(path)
                continue
            }

            // Explore neighbors
            for neighbor in current.orthogonalNeighbors() {
                if let neighborHeight = grid[neighbor], neighborHeight == grid[current]! + 1 {
                    let newPath = path + [neighbor]
                    if !visitedPaths.contains(newPath) {
                        visitedPaths.insert(newPath)
                        queue.append((neighbor, newPath))
                    }
                }
            }
        }

        return distinctPaths.count
    }

}

extension Point {
    func orthogonalNeighbors() -> [Point] {
        return [
            Point(x + 1, y),
            Point(x - 1, y),
            Point(x, y + 1),
            Point(x, y - 1),
        ]
    }
}
