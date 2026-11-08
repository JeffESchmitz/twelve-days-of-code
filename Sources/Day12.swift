//
// Twelve Days of Code 2025 Day 12
//
// https://adventofcode.com/2025/day/12
//

import Algorithms
import AoCTools
import Foundation

final class Day12: AdventOfCodeDay {
    let title = "Christmas Tree Farm"

    // Bitmask representation of a shape for O(1) collision checks
    private struct BitShape: Hashable {
        let rows: [UInt64]
        let width: Int
        let height: Int
        let area: Int
        // The anchor is the coordinate of the first '#' pixel (row-major order)
        // relative to the bounding box top-left.
        let anchor: Point

        // Precomputed bounds relative to anchor for fast validity checks
        let relMinX: Int
        let relMaxX: Int
        let relMaxY: Int
    }

    // Task represents a specific shape type to place
    private struct Task {
        let orientations: [BitShape]
        var count: Int
        let area: Int
    }

    private let shapes: [[BitShape]]
    private let regions: [(width: Int, height: Int, counts: [Int])]

    init(input: String) {
        let sections = input.components(separatedBy: "\n\n")

        // 1. Parse shapes into points, then precompute all orientations as BitShapes
        self.shapes = sections
            .filter { $0.contains(":") && !$0.contains("x") }
            .compactMap { section -> Set<Point>? in
                let lines = section.split(separator: "\n").dropFirst()
                let points = lines.enumerated().flatMap { y, line in
                    line.enumerated().compactMap { x, char in
                        char == "#" ? Point(x, y) : nil
                    }
                }
                return points.isEmpty ? nil : Set(points)
            }
            .map { points in
                Day12.allOrientations(points).map { Day12.toBitShape($0) }
            }

        // 2. Parse regions (WxH: count0 count1 ...)
        self.regions = sections.flatMap { section in
            section.split(separator: "\n")
                .filter { $0.contains("x") && $0.contains(":") }
                .compactMap { line -> (Int, Int, [Int])? in
                    let parts = line.split(separator: ":")
                    guard parts.count == 2 else { return nil }
                    let dims = parts[0].split(separator: "x")
                    guard dims.count == 2,
                          let w = Int(dims[0]),
                          let h = Int(dims[1]) else { return nil }
                    let counts = parts[1].split(separator: " ").compactMap { Int($0) }
                    return (w, h, counts)
                }
        }

        // Ensure standard integer type (64-bit) can hold the grid width
        precondition(!regions.contains { $0.width > 64 }, "Grid width > 64 not supported")
    }

    func part1() async -> Int {
        await withTaskGroup(of: Bool.self, returning: Int.self) { group in
            regions.forEach { region in
                group.addTask {
                    self.solveRegion(width: region.width, height: region.height, counts: region.counts)
                }
            }
            return await group.reduce(0) { $0 + ($1 ? 1 : 0) }
        }
    }

    func part2() async -> Int {
        // Day 12 has no Part 2 puzzle - just story/flavor text
        return 0
    }

    // MARK: - Core Logic

    private func solveRegion(width: Int, height: Int, counts: [Int]) -> Bool {
        // Build tasks from shape counts
        var tasks = counts.enumerated()
            .filter { $0.element > 0 }
            .map { i, count in
                Task(orientations: shapes[i], count: count, area: shapes[i][0].area)
            }

        // Area check: shapes must fit in grid
        let gridArea = width * height
        let shapeArea = tasks.reduce(0) { $0 + $1.count * $1.area }
        guard shapeArea <= gridArea else { return false }

        // Add slack (1x1 void shapes) for exact cover
        let slack = gridArea - shapeArea
        if slack > 0 {
            let voidShape = BitShape(
                rows: [1], width: 1, height: 1, area: 1, anchor: Point(0, 0),
                relMinX: 0, relMaxX: 0, relMaxY: 0
            )
            tasks.append(Task(orientations: [voidShape], count: slack, area: 1))
        }

        // Sort by area descending (place largest pieces first)
        tasks.sort { $0.area > $1.area }

        var grid = [UInt64](repeating: 0, count: height)
        return backtrack(grid: &grid, width: width, height: height, tasks: &tasks)
    }

    // Iterative backtracking to avoid stack overflow
    private func backtrack(grid: inout [UInt64], width: Int, height: Int, tasks: inout [Task]) -> Bool {
        struct Frame {
            var taskIdx: Int
            var orientationIdx: Int
            var placed: (taskIdx: Int, shape: BitShape, px: Int, py: Int)?
        }

        let fullRow = (width == 64) ? UInt64.max : UInt64((1 << width) - 1)
        var stack: [Frame] = [Frame(taskIdx: 0, orientationIdx: 0, placed: nil)]

        while !stack.isEmpty {
            let frame = stack.removeLast()

            // Undo previous placement if we're backtracking
            if let p = frame.placed {
                remove(grid: &grid, shape: p.shape, x: p.px, y: p.py)
                tasks[p.taskIdx].count += 1
            }

            // Find first empty cell using firstIndex
            guard let fy = grid.firstIndex(where: { $0 != fullRow }) else {
                return true  // Success: grid is full
            }
            let fx = ((~grid[fy]) & fullRow).trailingZeroBitCount

            // Try placements using labeled loop for clean breaking
            searchLoop: for i in frame.taskIdx..<tasks.count where tasks[i].count > 0 {
                let startOrient = (i == frame.taskIdx) ? frame.orientationIdx : 0

                for j in startOrient..<tasks[i].orientations.count {
                    let shape = tasks[i].orientations[j]
                    let px = fx - shape.anchor.x
                    let py = fy - shape.anchor.y

                    if px >= 0 && py >= 0 &&
                       px + shape.width <= width &&
                       py + shape.height <= height &&
                       canPlace(grid: grid, shape: shape, x: px, y: py) {

                        // Place the shape
                        place(grid: &grid, shape: shape, x: px, y: py)
                        tasks[i].count -= 1

                        // Push continuation frame (for backtracking), then new exploration frame
                        stack.append(Frame(taskIdx: i, orientationIdx: j + 1, placed: (i, shape, px, py)))
                        stack.append(Frame(taskIdx: 0, orientationIdx: 0, placed: nil))
                        break searchLoop
                    }
                }
            }
            // If no placement found, backtracking continues automatically
        }

        return false
    }

    // MARK: - Bit Operations

    @inline(__always)
    private func canPlace(grid: [UInt64], shape: BitShape, x: Int, y: Int) -> Bool {
        guard x >= 0 && y >= 0 && y + shape.height <= grid.count else { return false }
        return shape.rows.enumerated().allSatisfy { r, rowMask in
            (grid[y + r] & (rowMask << x)) == 0
        }
    }

    @inline(__always)
    private func place(grid: inout [UInt64], shape: BitShape, x: Int, y: Int) {
        shape.rows.enumerated().forEach { r, rowMask in
            grid[y + r] |= (rowMask << x)
        }
    }

    @inline(__always)
    private func remove(grid: inout [UInt64], shape: BitShape, x: Int, y: Int) {
        shape.rows.enumerated().forEach { r, rowMask in
            grid[y + r] &= ~(rowMask << x)
        }
    }

    // MARK: - Static Helpers

    private static func allOrientations(_ points: Set<Point>) -> [Set<Point>] {
        // Generate all 8 orientations (4 rotations × 2 flips), deduplicated
        let rotate90: (Set<Point>) -> Set<Point> = { Set($0.map { $0.rotated(by: 90) }) }
        let flipH: (Set<Point>) -> Set<Point> = { Set($0.map { Point(-$0.x, $0.y) }) }

        let rotations = sequence(first: points, next: rotate90).prefix(4)
        let allTransforms = rotations.flatMap { [normalize($0), normalize(flipH($0))] }
        return Array(Set(allTransforms))
    }

    private static func normalize(_ points: Set<Point>) -> Set<Point> {
        let (minX, _) = points.map(\.x).minAndMax() ?? (0, 0)
        let (minY, _) = points.map(\.y).minAndMax() ?? (0, 0)
        return Set(points.map { Point($0.x - minX, $0.y - minY) })
    }

    private static func toBitShape(_ points: Set<Point>) -> BitShape {
        let (_, maxX) = points.map(\.x).minAndMax() ?? (0, 0)
        let (_, maxY) = points.map(\.y).minAndMax() ?? (0, 0)
        let width = maxX + 1
        let height = maxY + 1

        // Find anchor: first point in row-major order (top-left most)
        let anchor = points.min { a, b in
            a.y != b.y ? a.y < b.y : a.x < b.x
        } ?? Point(0, 0)

        // Build bitmask rows
        let rows = points.reduce(into: [UInt64](repeating: 0, count: height)) { rows, p in
            rows[p.y] |= (1 << p.x)
        }

        return BitShape(
            rows: rows,
            width: width,
            height: height,
            area: points.count,
            anchor: anchor,
            relMinX: -anchor.x,
            relMaxX: (width - 1) - anchor.x,
            relMaxY: (height - 1) - anchor.y
        )
    }
}
