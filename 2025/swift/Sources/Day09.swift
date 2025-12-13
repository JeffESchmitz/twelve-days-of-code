//
// Twelve Days of Code 2025 Day 9
//
// https://adventofcode.com/2025/day/9
//

import AoCTools

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
        // Part 2 not yet revealed - need to submit Part 1 answer first
        return -1
    }
}
