//
// Advent of Code 2024 Day 12
//
// https://adventofcode.com/2024/day/12
//

import AoCTools

final class Day12: AdventOfCodeDay, @unchecked Sendable {
    let title = "Garden Groups"
    let grid: Grid<Character>

    init(input: String) {
        grid = Grid<Character>.parse(input.lines)
    }

    func part1() async -> Int {
        let regions = findRegions()
        return computeTotalPrice(for: regions) // area * perimeter for each region
    }

    func part2() async -> Int {
        let regions = findRegions()
        return regions.reduce(into: 0) { total, region in
            let area = region.count
            let boundarySegments = computeEdges(for: region)
            total += area * boundarySegments
        }
    }
}

// MARK: - Region Finding (BFS)

extension Day12 {
    /// Collect all contiguous same-letter regions from the grid using BFS.
    /// Each region is returned as an array of Points belonging to that region.
    private func findRegions() -> [[Point]] {
        var visited = Set<Point>()
        var result = [[Point]]()

        // BFS start from any cell not yet visited
        for point in grid.points.keys where !visited.contains(point) {
            let region = bfsRegion(start: point, visited: &visited)
            result.append(region)
        }
        return result
    }

    /// BFS to gather all points belonging to the same region that starts at `start`.
    /// - Returns: An array of Points in one contiguous region of matching characters.
    private func bfsRegion(start: Point, visited: inout Set<Point>) -> [Point] {
        var region = [Point]()
        var queue = [start]

        while let current = queue.first {
            queue.removeFirst()
            guard !visited.contains(current) else { continue }

            visited.insert(current)
            region.append(current)

            // Enqueue same-character neighbors
            guard let currentChar = grid.points[current] else { continue }
            for neighbor in orthogonalNeighbors(of: current) {
                if let neighborChar = grid.points[neighbor],
                   neighborChar == currentChar,
                   !visited.contains(neighbor) {
                    queue.append(neighbor)
                }
            }
        }

        return region
    }

    /// Get orthogonal neighbors (up/down/left/right) within grid bounds.
    private func orthogonalNeighbors(of point: Point) -> [Point] {
        let directions = [Point(1,0), Point(-1,0), Point(0,1), Point(0,-1)]
        return directions
            .map { point + $0 }
            .filter { grid.points.keys.contains($0) }
    }
}

// MARK: - Part 1 Calculation: "Area * Perimeter"

extension Day12 {
    /// Summation of (area * perimeter) for every region in `regions`.
    private func computeTotalPrice(for regions: [[Point]]) -> Int {
        regions.reduce(0) { total, region in
            let area = region.count
            let perimeter = calculatePerimeter(for: region)
            return total + area * perimeter
        }
    }

    /// Standard grid perimeter = sum over each cell of (4 - numberOfNeighborsInRegion).
    private func calculatePerimeter(for region: [Point]) -> Int {
        let regionSet = Set(region)
        var perimeter = 0

        for point in region {
            for neighbor in point.orthogonalNeighbors() {
                // If neighbor is out of the region, count an edge
                if grid.points[neighbor] == nil || !regionSet.contains(neighbor) {
                    perimeter += 1
                }
            }
        }
        return perimeter
    }
}

// MARK: - Part 2 Calculation: "Area * Edges"

extension Day12 {
    /// Computes puzzle-specific edges by scanning row-wise and column-wise for boundary segments.
    private func computeEdges(for region: [Point]) -> Int {
        let regionSet = Set(region)
        guard !regionSet.isEmpty else { return 0 }

        let minX = regionSet.map(\.x).min()!
        let maxX = regionSet.map(\.x).max()!
        let minY = regionSet.map(\.y).min()!
        let maxY = regionSet.map(\.y).max()!

        var edges = 0

        // 1) Top-to-bottom
        for y in minY...maxY {
            // Exposed top edge means no cell above (y-1)
            let rowPoints = regionSet
                .filter { p in p.y == y && !regionSet.contains(Point(p.x, y - 1)) }
                .sorted { $0.x < $1.x }
            edges += chunked(rowPoints, by: { $0.x + 1 == $1.x }).count
        }

        // 2) Bottom-to-top
        for y in (minY...maxY).reversed() {
            let rowPoints = regionSet
                .filter { p in p.y == y && !regionSet.contains(Point(p.x, y + 1)) }
                .sorted { $0.x < $1.x }
            edges += chunked(rowPoints, by: { $0.x + 1 == $1.x }).count
        }

        // 3) Left-to-right
        for x in minX...maxX {
            let colPoints = regionSet
                .filter { p in p.x == x && !regionSet.contains(Point(x - 1, p.y)) }
                .sorted { $0.y < $1.y }
            edges += chunked(colPoints, by: { $0.y + 1 == $1.y }).count
        }

        // 4) Right-to-left
        for x in (minX...maxX).reversed() {
            let colPoints = regionSet
                .filter { p in p.x == x && !regionSet.contains(Point(x + 1, p.y)) }
                .sorted { $0.y < $1.y }
            edges += chunked(colPoints, by: { $0.y + 1 == $1.y }).count
        }

        return edges
    }

    /// Splits an array into contiguous chunks where `areContiguous(a,b)` is `true` for adjacent items in the same chunk.
    private func chunked<T>(_ array: [T], by areContiguous: (T, T) -> Bool) -> [[T]] {
        guard !array.isEmpty else { return [] }

        var result = [[T]]()
        var currentChunk = [array[0]]

        for i in 1..<array.count {
            if areContiguous(array[i-1], array[i]) {
                currentChunk.append(array[i])
            } else {
                result.append(currentChunk)
                currentChunk = [array[i]]
            }
        }
        result.append(currentChunk)
        return result
    }
}
