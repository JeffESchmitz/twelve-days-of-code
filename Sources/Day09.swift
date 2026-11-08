//
// Twelve Days of Code 2025 Day 9
//
// https://adventofcode.com/2025/day/9
//

import AoCTools

// MARK: - Polygon Edge Types

private struct HorizontalEdge {
    let yPos: Int
    let xMin: Int
    let xMax: Int
}

private struct VerticalEdge {
    let xPos: Int
    let yMin: Int
    let yMax: Int
}

final class Day09: AdventOfCodeDay {
    let title = "Movie Theater"

    // Red tile coordinates
    let tiles: [Point]

    init(input: String) {
        // Parse "x,y" coordinates
        self.tiles = input.lines.compactMap { line -> Point? in
            let nums = line.integers()
            guard nums.count == 2 else { return nil }
            return Point(nums[0], nums[1])
        }
    }

    func part1() async -> Int {
        // Find largest rectangle using any two tiles as opposite corners
        // Area includes both corners as tiles (inclusive counting)
        // width = |x2 - x1| + 1, height = |y2 - y1| + 1
        var maxArea = 0

        for firstIdx in 0..<tiles.count {
            for secondIdx in (firstIdx + 1)..<tiles.count {
                let tile1 = tiles[firstIdx]
                let tile2 = tiles[secondIdx]

                let width = abs(tile2.x - tile1.x) + 1
                let height = abs(tile2.y - tile1.y) + 1
                let area = width * height

                maxArea = max(maxArea, area)
            }
        }

        return maxArea
    }

    func part2() async -> Int {
        // Rectangle must only contain red or green tiles
        // Green tiles: edges between consecutive red tiles + interior of polygon
        let horizontalEdges = buildHorizontalEdges()
        let verticalEdges = buildVerticalEdges()

        // Check if point is on polygon boundary
        func isOnBoundary(_ point: Point) -> Bool {
            for edge in horizontalEdges
            where point.y == edge.yPos && edge.xMin <= point.x && point.x <= edge.xMax {
                return true
            }
            for edge in verticalEdges
            where point.x == edge.xPos && edge.yMin <= point.y && point.y <= edge.yMax {
                return true
            }
            return false
        }

        // Check if point is inside polygon using ray casting
        func isInsidePolygon(_ point: Point) -> Bool {
            var crossings = 0
            for edge in verticalEdges {
                if edge.xPos > point.x && edge.yMin <= point.y && point.y < edge.yMax {
                    crossings += 1
                }
            }
            return crossings % 2 == 1
        }

        func isValidPoint(_ point: Point) -> Bool {
            isOnBoundary(point) || isInsidePolygon(point)
        }

        // Check if rectangle is entirely within polygon
        func rectangleIsValid(minX: Int, minY: Int, maxX: Int, maxY: Int) -> Bool {
            guard isValidPoint(Point(minX, minY)),
                  isValidPoint(Point(minX, maxY)),
                  isValidPoint(Point(maxX, minY)),
                  isValidPoint(Point(maxX, maxY)) else {
                return false
            }

            // No vertical polygon edge should cross rectangle interior
            for edge in verticalEdges
            where minX < edge.xPos && edge.xPos < maxX && edge.yMin < maxY && edge.yMax > minY {
                return false
            }

            // No horizontal polygon edge should cross rectangle interior
            for edge in horizontalEdges
            where minY < edge.yPos && edge.yPos < maxY && edge.xMin < maxX && edge.xMax > minX {
                return false
            }

            return true
        }

        // Find largest valid rectangle
        var maxArea = 0
        let tileCount = tiles.count

        for firstIdx in 0..<tileCount {
            for secondIdx in (firstIdx + 1)..<tileCount {
                let tile1 = tiles[firstIdx]
                let tile2 = tiles[secondIdx]

                let minX = min(tile1.x, tile2.x)
                let maxX = max(tile1.x, tile2.x)
                let minY = min(tile1.y, tile2.y)
                let maxY = max(tile1.y, tile2.y)

                if rectangleIsValid(minX: minX, minY: minY, maxX: maxX, maxY: maxY) {
                    let area = (maxX - minX + 1) * (maxY - minY + 1)
                    maxArea = max(maxArea, area)
                }
            }
        }

        return maxArea
    }

    // MARK: - Private Helpers

    private func buildHorizontalEdges() -> [HorizontalEdge] {
        var edges: [HorizontalEdge] = []
        for idx in 0..<tiles.count {
            let current = tiles[idx]
            let next = tiles[(idx + 1) % tiles.count]
            if current.y == next.y {
                edges.append(HorizontalEdge(
                    yPos: current.y,
                    xMin: min(current.x, next.x),
                    xMax: max(current.x, next.x)
                ))
            }
        }
        return edges
    }

    private func buildVerticalEdges() -> [VerticalEdge] {
        var edges: [VerticalEdge] = []
        for idx in 0..<tiles.count {
            let current = tiles[idx]
            let next = tiles[(idx + 1) % tiles.count]
            if current.x == next.x {
                edges.append(VerticalEdge(
                    xPos: current.x,
                    yMin: min(current.y, next.y),
                    yMax: max(current.y, next.y)
                ))
            }
        }
        return edges
    }
}
